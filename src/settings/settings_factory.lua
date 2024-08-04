-- https://github.com/spatie/ray/blob/main/src/Settings/SettingsFactory.php

local lfs = require("lfs")

---@type Settings
local Settings = require("ray.settings")

---@class SettingsFactory
---@field public cache table<string, string>
local SettingsFactory = {}
SettingsFactory.__index = SettingsFactory
SettingsFactory.cache = {}

---@param settings SettingsOptions?
---@return Settings
function SettingsFactory.create_from_array(settings)
	return Settings.new(settings)
end

---@param config_directory string?
---@return Settings
function SettingsFactory.create_from_config_file(config_directory)
	local setting_values = SettingsFactory:get_settings_from_config_file(config_directory)
	local settings = SettingsFactory.create_from_array(setting_values)

	if next(setting_values) ~= nil then
		settings:mark_as_loaded_using_settings_file()
	end

	return settings
end

---@param config_directory string?
---@return SettingsOptions
function SettingsFactory:get_settings_from_config_file(config_directory)
	local config_file_path = self:search_config_files(config_directory)

	-- this is to fake the PHP file_exists function
	-- os.rename will return nil if the file does not exist
	if not os.rename(config_file_path, config_file_path) then
		return {}
	end

	---@type SettingsOptions
	local options = dofile(config_file_path)

	return options or {}
end

---@protected
---@param config_directory string?
---@return string
function SettingsFactory:search_config_files(config_directory)
	if config_directory == nil then
		config_directory = lfs.currentdir()
	end

	if not SettingsFactory.cache[config_directory] then
		SettingsFactory.cache[config_directory] = self:search_config_files_on_disk(config_directory)
	end

	return SettingsFactory.cache[config_directory]
end

---@protected
---@param config_directory string?
---@return string
function SettingsFactory:search_config_files_on_disk(config_directory)
	local config_names = {
		"ray.lua",
	}

	while lfs.attributes(config_directory, "mode") == "directory" do
		for _, config_name in ipairs(config_names) do
			local config_full_path = config_directory .. "/" .. config_name

			-- this is to fake the PHP file_exists function
			-- os.rename will return nil if the file does not exist
			if os.rename(config_full_path, config_full_path) then
				return config_full_path
			end
		end

		--TODO: handle nil
		local parent_directory = config_directory:match("(.*[/\\])")

		if parent_directory == config_directory then
			return ""
		end

		config_directory = parent_directory
	end

	return ""
end

return SettingsFactory
