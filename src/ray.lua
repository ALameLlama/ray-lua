-- https://github.com/spatie/ray/blob/main/src/Ray.php

local Uuid = require("uuid")

---@type SettingsFactory
local SettingsFactory = require("src.settings.settings_factory")

---@type Client
local Client = require("src.client")

---@type SupportCounters
local Counters = require("src.support.counters")

---@type SupportLimiters
local Limiters = require("src.support.limiters")

---@type SupportRateLimiter
local RateLimiter = require("src.support.rate_limiter")

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

return Ray
