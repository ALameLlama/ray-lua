-- https://github.com/spatie/ray/blob/main/src/helpers.php
---@diagnostic disable: lowercase-global

local SettingsFactory = require("ray.settings.settings_factory")
local Ray = require("ray.ray")

function ray(...)
	local settings = SettingsFactory.create_from_config_file()
	local ray_instance = Ray:new(settings)

	return ray_instance:send(...)
end

function rd(...)
	return ray(...):die()
end
