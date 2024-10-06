-- https://github.com/spatie/ray/blob/1.41.2/src/Ray.php

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

---@type SupportStopwatch
local Stopwatch = require("ray.support.stopwatch")

-- Payloads
---@type PayloadFactory
local PayloadFactory = require("ray.payload.payload_factory")

local ClearAllPayload = require("ray.payload.clear_all_payload")
local ColorPayload = require("ray.payload.color_payload")
local CustomPayload = require("ray.payload.custom_payload")
local HidePayload = require("ray.payload.hide_payload")
local HtmlPayload = require("ray.payload.html_payload")
local JsonStringPayload = require("ray.payload.json_string_payload")
local LabelPayload = require("ray.payload.label_payload")
local LogPayload = require("ray.payload.log_payload")
local MeasurePayload = require("ray.payload.measure_payload")
local NewScreenPayload = require("ray.payload.new_screen_payload")
local NotifyPayload = require("ray.payload.notify_payload")
local RemovePayload = require("ray.payload.remove_payload")
local ScreenColorPayload = require("ray.payload.screen_color_payload")
local SizePayload = require("ray.payload.size_payload")

local Colors = require("ray.concerns.colors")
local ScreenColors = require("ray.concerns.screen_colors")
local Sizes = require("ray.concerns.sizes")

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
---@field public screen_green fun(): Ray
---@field public screen_orange fun(): Ray
---@field public screen_red fun(): Ray
---@field public screen_purple fun(): Ray
---@field public screen_blue fun(): Ray
---@field public screen_gray fun(): Ray
---@field public screen_grey fun(): Ray
---@field public green fun(): Ray
---@field public orange fun(): Ray
---@field public red fun(): Ray
---@field public purple fun(): Ray
---@field public blue fun(): Ray
---@field public gray fun(): Ray
---@field public grey fun(): Ray
---@field public small fun(): Ray
---@field public large fun(): Ray
local Ray = {}
Ray.__index = Ray
Ray.uuid = ""
Ray.can_send_payload = true
Ray.caught_exception = {}
Ray.stop_watches = {}
Ray._enabled = nil
Ray.project_name = ""
Ray.before_send_request = nil

-- Trait system
local function use(instance, ...)
	local traits = { ... }
	for _, trait in ipairs(traits) do
		for key, value in pairs(trait) do
			if type(value) == "function" then
				instance[key] = function(...)
					return value(instance, ...)
				end
			end
		end
	end
end

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

	-- This is currently setting all the properties of the Ray "singleton" instead of the object it self.
	-- Without this chaining methods break, I think I am doing something wrong here.
	-- I think I should update everthing to use : instead of . so everthing has access to the updated self object?
	-- This is acting more as a singleton atm.
	Ray.settings = settings
	Ray.client = client or Ray.client or Client.new(settings.port, settings.host)
	Ray.counters = Ray.counters or Counters
	Ray.limiters = Ray.limiters or Limiters
	Ray.uuid = uuid or Ray.fake_uuid or Uuid()
	Ray.rate_limiter = Ray.rate_limiter or RateLimiter:disabled()
	Ray.enabled = Ray.enabled or self.settings.enable or true

	use(self, Colors, ScreenColors, Sizes)

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

---@param color string  Supported colors are: green, orange, red, purple, blue, gray
---@return Ray
function Ray.color(color)
	-- Incase someones spells grey correctly
	if color == "grey" then
		color = "gray"
	end

	local payload = ColorPayload(color)

	return Ray:send_request(payload)
end

-- Incase someones spells colour correctly
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

---@param stopwatch_name string|function|nil
---@return Ray
function Ray.measure(stopwatch_name)
	if type(stopwatch_name) == "function" then
		return Ray.measure_closure(stopwatch_name)
	end

	if stopwatch_name == nil then
		stopwatch_name = "default"
	end

	if not Ray.stop_watches[stopwatch_name] then
		local stopwatch = Stopwatch.new(true)
		Ray.stop_watches[stopwatch_name] = stopwatch

		local event = stopwatch:start(stopwatch_name)

		local payload = MeasurePayload(stopwatch_name, event)
		payload:concerns_new_timer()

		return Ray:send_request(payload)
	end

	local stopwatch = Ray.stop_watches[stopwatch_name]
	local event = stopwatch:lap(stopwatch_name)
	local payload = MeasurePayload(stopwatch_name, event)

	return Ray:send_request(payload)
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

---@param closure function
---@return Ray
function Ray.measure_closure(closure)
	local stopwatch = Stopwatch.new(true)

	stopwatch:start("closure")

	closure()

	local event = stopwatch:stop("closure")

	local payload = MeasurePayload("Closure", event)

	return Ray:send_request(payload)
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

function Ray.json(...)
	error("Not implemented")
end

function Ray.file(filename)
	error("Not implemented")
end

function Ray.image(location)
	error("Not implemented")
end

---@overload fun()
---@param status boolean|integer
function Ray:die(status)
	os.exit(status or 1)
end

function Ray.class_name(object)
	error("Not implemented")
end

function Ray.luainfo(properties)
	error("Not implemented")
end

function Ray._if(bool_or_callable, callable)
	error("Not implemented")
end

function Ray.carbon(carbon)
	error("Not implemented")
end

---@return Ray
function Ray.ban()
	return Ray:send("🕶")
end

---@return Ray
function Ray.charles()
	return Ray:send("🎶 🎹 🎷 🕺")
end

function Ray.table(values, label)
	error("Not implemented")
end

function Ray.count(name)
	error("Not implemented")
end

function Ray.clear_counters()
	error("Not implemented")
end

function Ray.counters_value(name)
	error("Not implemented")
end

function Ray.pause()
	error("Not implemented")
end

function Ray.separator()
	error("Not implemented")
end

function Ray.url(url, label)
	error("Not implemented")
end

function Ray.link(url, label)
	error("Not implemented")
end

---@param html string
---@return Ray
function Ray.html(html)
	local payload = HtmlPayload(html)

	return Ray:send_request(payload)
end

function Ray.confetti()
	error("Not implemented")
end

function Ray.exception(exception)
	error("Not implemented")
end

function Ray.xml(xml)
	error("Not implemented")
end

function Ray.text(text)
	error("Not implemented")
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

function Ray.limit(count)
	error("Not implemented")
end

function Ray.once(...)
	error("Not implemented")
end

function Ray.catch(callback)
	error("Not implemented")
end

function Ray.throw_exception()
	error("Not implemented")
end

function Ray.invade(object)
	error("Not implemented")
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
		if type(argument) ~= "function" then
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

function Ray.pass(argument)
	error("Not implemented")
end

function Ray.show_app()
	error("Not implemented")
end

function Ray.hide_app()
	error("Not implemented")
end

function Ray.send_custom(centent, label)
	error("Not implemented")
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

	if not payloads or Utils.payloads_is_empty(payloads) then
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

	if Utils.payload_is_object(payloads) then
		payloads = { payloads }
	end

	if self.rate_limiter:is_max_reached() or self.rate_limiter:is_max_per_second_reached() then
		self:notify_when_rate_limit_reached()
		return self
	end

	local all_meta = Utils.array_merge({
		lua_version = _VERSION,
		ray_package_version = "2.0.0",
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

-- TODO: see if I need these
-- before_send_request

-- TODO: they have traits to add more functions like size and color

---@protected
function Ray:notify_when_rate_limit_reached()
	if self.rate_limiter:is_notified() then
		return
	end

	local custom_payload = CustomPayload("Rate limit has bee  reached...", "Rate limit")

	self.client:send(Request(self.uuid, custom_payload, {}))

	self.rate_limiter:notify()
end

return Ray
