-- https://github.com/spatie/ray/blob/1.41.2/tests/SettingsTest.php

local lu = require("luaunit")
local lfs = require("lfs")

---@type SettingsFactory
local SettingsFactory = require("ray.settings.settings_factory")

local TestUtils = require("ray.test.utils")

TestSettings = {}

function TestSettings:testCanUseTheDefaultSettings()
	local settings = SettingsFactory.create_from_config_file()

	lu.assertEquals(settings.host, "localhost")
	lu.assertEquals(settings.port, 23517)
end

function TestSettings:testCanFindTheSettingsFile()
	local settings = SettingsFactory.create_from_config_file(
		TestUtils.make_path_os_safe(lfs.currentdir() .. "/tests/test_settings/sub_directory/sub_sub_directory")
	)

	lu.assertEquals(settings.port, 12345)
	lu.assertEquals(settings.host, "http://otherhost")
end

function TestSettings:testCanFindTheSettingsFileMoreThanOnce()
	local settings1 = SettingsFactory.create_from_config_file(
		TestUtils.make_path_os_safe(lfs.currentdir() .. "/tests/test_settings/sub_directory/sub_sub_directory")
	)

	lu.assertEquals(settings1.port, 12345)
	lu.assertEquals(settings1.host, "http://otherhost")

	local settings2 = SettingsFactory.create_from_config_file(
		TestUtils.make_path_os_safe(lfs.currentdir() .. "/tests/test_settings/sub_directory/sub_sub_directory")
	)

	lu.assertEquals(settings2.port, 12345)
	lu.assertEquals(settings2.host, "http://otherhost")
end

function TestSettings:testCanCreateSettingsFromArray()
	---@diagnostic disable: missing-fields
	local settings = SettingsFactory.create_from_array({ enabled = false, port = 1234 })

	---@diagnostic disable: undefined-field
	lu.assertEquals(settings.enabled, false)
	lu.assertEquals(settings.port, 1234)
end
