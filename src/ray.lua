-- https://github.com/spatie/ray/blob/main/src/Ray.php

local Uuid = require("uuid")
local Utils = require("ray.utils")

---@type SettingsFactory
local SettingsFactory = require("ray.settings.settings_factory")

---@type Client
local Client = require("ray.client")

---@type Request
local Request = require("ray.request")

-- Support
---@type SupportCounters
local Counters = require("ray.support.counters")

---@type SupportLimiters
local Limiters = require("ray.support.limiters")

---@type SupportIgnoredValue
local IgnoredValue = require("ray.support.ignored_value")

---@type SupportRateLimiter
local RateLimiter = require("ray.support.rate_limiter")

-- Payloads
---@type PayloadFactory
local PayloadFactory = require("ray.payload.payload_factory")

local CustomPayload = require("ray.payload.custom_payload")
local LogPayload = require("ray.payload.log_payload")
local NewScreenPayload = require("ray.payload.new_screen_payload")
local ClearAllPayload = require("ray.payload.clear_all_payload")
local ColorPayload = require("ray.payload.color_payload")
local ScreenColorPayload = require("ray.payload.screen_color_payload")
local LabelPayload = require("ray.payload.label_payload")
local SizePayload = require("ray.payload.size_payload")
local RemovePayload = require("ray.payload.remove_payload")
local HidePayload = require("ray.payload.hide_payload")
local NotifyPayload = require("ray.payload.notify_payload")
local JsonStringPayload = require("ray.payload.json_string_payload")

---@class Ray
---@field public settings Settings
---@field protected client Client
---@field public counters SupportCounters
---@field public limiters SupportLimiters
---@field public fake_uuid string
---@field public limit_origin Origin?
---@field public uuid string
---@field public can_send_payload boolean
---@field public caught_exception table
---@field public stop_watches table
---@field public _enabled boolean? underscore is used to avoid conflict with the enabled method
---@field public rate_limiter SupportRateLimiter
---@field public project_name string
---@field public before_send_request function?
local Ray = {}
Ray.__index = Ray
Ray.client = nil
Ray.caught_exception = {}
Ray.stop_watches = {}
Ray.enabled = nil
Ray.project_name = ""

---@param client Client
---@param uuid string
---@return Ray
function Ray.create(client, uuid)
	---@type Settings
	local settings = SettingsFactory.create_from_config_file()

	return Ray.new(settings, client, uuid)
end

---@overload fun(settings: Settings): Ray
---@overload fun(settings: Settings, client: Client): Ray
---@overload fun(settings: Settings, client: Client, uuid: string): Ray
---@param settings Settings
---@param client Client
---@param uuid string
---@return Ray
function Ray.new(settings, client, uuid)
	local self = setmetatable({}, Ray)

	self.settings = settings
	Ray.client = client or Ray.client or Client.new(settings.port, settings.host)
	Ray.counters = Ray.counters or Counters
	Ray.limiters = Ray.limiters or Limiters
	self.uuid = uuid or Ray.fake_uuid or Uuid()
	Ray.rate_limiter = Ray.rate_limiter or RateLimiter:disabled()
	Ray.enabled = Ray.enabled or self.settings.enable or true

	return self
end

---@param project_name string
---@return Ray
function Ray.project(project_name)
	Ray.project_name = project_name

	return Ray
end

---@return Ray
function Ray.enable()
	Ray._enabled = true

	return Ray
end

---@return Ray
function Ray.disable()
	Ray._enabled = false

	return Ray
end

---@return boolean
function Ray.enabled()
	return Ray._enabled or Ray._enabled == nil
end

---@return boolean
function Ray.disabled()
	return Ray._enabled == false
end

---@param client Client
function Ray.use_client(client)
	Ray.client = client
end

---@overload fun(): Ray
---@param name string
---@return Ray
function Ray.new_screen(name)
	-- TODO: sanitize name
	name = name or ""

	local payload = NewScreenPayload(name)

	return Ray:send_request(payload)
end

---@return Ray
function Ray.clear_all()
	local payload = ClearAllPayload()

	return Ray:send_request(payload)
end

---@return Ray
function Ray.clear_screen()
	return Ray.new_screen()
end

--TODO: add support for grey
---@param color string  Supported colors are: green, orange, red, purple, blue, gray
---@return Ray
function Ray.color(color)
	local payload = ColorPayload(color)

	return Ray:send_request(payload)
end

---@param color string  Supported colors are: green, orange, red, purple, blue, gray
---@return Ray
function Ray.colour(color)
	return Ray.color(color)
end

---@param color string
---@return Ray
function Ray.screen_color(color)
	local payload = ScreenColorPayload(color)

	return Ray:send_request(payload)
end

---@param color string
---@return Ray
function Ray.screen_colour(color)
	return Ray.screen_color(color)
end

---@param label string
---@return Ray
function Ray.label(label)
	local payload = LabelPayload(label)

	return Ray:send_request(payload)
end

---@param size string
---@return Ray
function Ray.size(size)
	local payload = SizePayload(size)

	return Ray:send_request(payload)
end

---@return Ray
function Ray.remove()
	local payload = RemovePayload()

	return Ray:send_request(payload)
end

---@return Ray
function Ray.hide()
	local payload = HidePayload()

	return Ray:send_request(payload)
end

---@param stopwatch_name string|function
function Ray.measure(stopwatch_name)
	error("Not implemented")
end

---@param starting_from_frame function?
function Ray.trace(starting_from_frame)
	error("Not implemented")
end

---@param starting_from_frame function?
function Ray.backtrace(starting_from_frame)
	return Ray.trace(starting_from_frame)
end

function Ray.caller()
	error("Not implemented")
end

function Ray.expand(...)
	error("Not implemented")
end

function Ray.expand_all()
	return Ray.expand(999)
end

function Ray.stop_time(stopwatch_name)
	error("Not implemented")
end

---@param text string
---@return Ray
function Ray.notify(text)
	local payload = NotifyPayload(text)

	return Ray:send_request(payload)
end

function Ray.to_json(...)
	local arguments = { ... }

	if #arguments == 0 then
		return Ray
	end

	local payloads = Utils.array_map(function(argument)
		return JsonStringPayload(argument)
	end, arguments)

	return Ray:send_request(payloads)
end

---@protected
function Ray:notify_when_rate_limit_reached()
	if self.rate_limiter:is_notified() then
		return
	end

	local custom_payload = CustomPayload("Rate limit has bee  reached...", "Rate limit")

	self.client:send(Request(self.uuid, custom_payload, {}))

	self.rate_limiter:notify()
end

---@overload fun(payload: Payload): Ray
---@param payloads Payload|Payload[]
---@param meta table
---@return Ray
function Ray:send_request(payloads, meta)
	meta = meta or {}

	if not self.enabled() then
		return Ray
	end

	if not payloads or #payloads == 0 then
		return Ray
	end

	if not self.can_send_payload then
		return Ray
	end

	if self.limit_origin then
		if not self.limiters:can_send_payload(self.limit_origin) then
			return self
		end

		self.limiters:increment(self.limit_origin)
	end

	if type(payloads) ~= "table" then
		payloads = { payloads }
	end

	if self.rate_limiter:is_max_reached() or self.rate_limiter:is_max_per_second_reached() then
		self:notify_when_rate_limit_reached()
		return self
	end

	local all_meta = Utils.array_merge({
		lua_version = _VERSION,
		project_name = self.project_name,
	}, meta)

	if self.before_send_request then
		self.before_send_request(payloads, all_meta)
	end

	for _, payload in ipairs(payloads) do
		payload.remote_path = self.settings.remote_path
		payload.local_path = self.settings.local_path
	end

	local request = Request(self.uuid, payloads, all_meta)

	self.client:send(request)

	self.rate_limiter:hit()

	return self
end

function Ray:send(...)
	local arguments = { ... }

	if #arguments == 0 then
		return self
	end

	if self.settings.always_send_raw_values then
		return self:raw(table.unpack(arguments))
	end

	arguments = Utils.array_map(function(argument)
		if type(argument) == "table" then
			return argument
		end

		if type(argument) == "function" then
			return argument
		end

		local status, result = pcall(argument, self)

		if not status then
			table.insert(self.caught_exception, result)

			return IgnoredValue.make()
		end

		return result
	end, arguments)

	--TODO: check if this is correct and filters out IgnoredValue
	arguments = Utils.array_filter(function(argument)
		return getmetatable(argument) ~= IgnoredValue
	end, arguments)

	if #arguments == 0 then
		return self
	end

	local payloads = PayloadFactory.create_for_values(arguments)

	return self:send_request(payloads)
end

function Ray:raw(...)
	local arguments = { ... }

	if #arguments == 0 then
		return self
	end

	local payloads = Utils.array_map(function(argument)
		-- In PHP this is LogPayload::createForArguments() but we don't have the convert stuff
		return LogPayload({ argument })
	end, arguments)

	return self:send_request(payloads)
end

---@overload fun()
---@param status boolean|integer
function Ray:die(status)
	os.exit(status or 1)
end

return Ray
