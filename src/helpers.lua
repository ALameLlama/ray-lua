-- https://github.com/spatie/ray/blob/1.41.2/src/helpers.php

---@diagnostic disable: lowercase-global

---@type SettingsFactory
local SettingsFactory = require("ray.settings.settings_factory")

---@type Ray
local Ray = require("ray.ray")

local function ray(...)
	local settings = SettingsFactory.create_from_config_file()
	local ray_instance = Ray.new(settings)

	return ray_instance:send(...)
end

local function rd(...)
	return ray(...):die()
end

return {
	ray,
	rd,
}
