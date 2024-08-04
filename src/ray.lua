-- https://github.com/spatie/ray/blob/main/src/Ray.php

local Uuid = require("uuid")

---@type SettingsFactory
local SettingsFactory = require("ray.settings.settings_factory")

---@type Client
local Client = require("ray.client")

-- TODO: most of these don't exist yet, see if they can be implemented and see if the defaults are correct.

---@class Ray
---@field public settings Settings
---@field protected client Client
---@field public counters Counters
---@field public limiters Limiters
---@field public fake_uuid string
---@field public limit_origin Origin?
---@field public uuid string
---@field public can_send_payload boolean
---@field public caught_exception table
---@field public stop_watches table
---@field public enabled boolean?
---@field public rate_limiter RateLimiter
---@field public project_name string
---@field public before_send_request function?
local Ray = {}
Ray.__index = Ray
Ray.client = nil
Ray.caught_exception = {}
Ray.stop_watches = {}
Ray.enabled = nil
Ray.project_name = ""

function Ray.create(client, uuid)
  ---@type Settings
  local settings = SettingsFactory.create_from_config_file()

  return Ray.new(settings, client, uuid)
end

function Ray.new(settings, client, uuid)
  local self = setmetatable({}, Ray)

  self.settings = settings
  self.client = client or Ray.client or Client.new(settings.port, settings.host)
  -- Ray.counters = Ray.counters or Counters.new()
  -- Ray.limiters = Ray.limiters or Limiters.new()
  self.uuid = uuid or Ray.fake_uuid or Uuid()
  -- Ray.enabled = Ray.enabled or obj.settings.enable or true
  -- Ray.rate_limiter = Ray.rate_limiter or RateLimiter:disabled()

  return self
end

return Ray
