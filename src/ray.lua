-- https://github.com/spatie/ray/blob/main/src/Ray.php

local Uuid = require("uuid")

---@type SettingsFactory
local SettingsFactory = require("src.settings.settings_factory")

---@type Client
local Client = require("src.client")

---@type Request
local Request = require("src.request")

---@type SupportCounters
local Counters = require("src.support.counters")

---@type SupportLimiters
local Limiters = require("src.support.limiters")

---@type SupportRateLimiter
local RateLimiter = require("src.support.rate_limiter")

---@type CustomPayload
local CustomPayload = require("src.payload.custom_payload")

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

---@protected
function Ray:notify_when_rate_limit_reached()
	if self.rate_limiter:is_notified() then
		return
	end

	local custom_payload = CustomPayload("Rate limit has been reached...", "Rate limit")

	self.client:send(Request(self.uuid, custom_payload, {}))

	self.rate_limiter:notify()
end

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

	local all_meta = {
		lua_version = _VERSION,
		project_name = self.project_name,
	}

	for k, v in pairs(meta) do
		all_meta[k] = v
	end

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

return Ray
