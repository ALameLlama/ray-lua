-- https://github.com/spatie/ray/blob/1.41.2/tests/RayTest.php

local lu = require("luaunit")

---@type TestClassClient
local Client = require("ray.test.class.client")
---@type Ray
local Ray = require("ray.ray")
---@type SettingsFactory
local SettingsFactory = require("ray.settings.settings_factory")
---@type OriginHostname
local Hostname = require("ray.origin.hostname")
---@type TestUtils
local TestUtils = require("ray.test.utils")

TestRay = {}

function TestRay:setUp()
  Hostname:set("fake-hostname")

  ---@type TestClassClient
  self.client = Client.new()
  self.settings = SettingsFactory.create_from_config_file()

  ---@diagnostic disable-next-line: param-type-mismatch
  self.ray = Ray.new(self.settings, self.client, "fakeUuid")
  self.ray:enable()
  self.ray.rate_limiter:clear()
end

function TestRay:testCanSendAStringToRay()
  self.ray:send("a")

  lu.assertEquals(self.client:sent_payloads(), TestUtils.getSnapshot("ray_test_can_send_a_string_to_ray"))
end

function TestRay:testCanSendAStringsThatMightBeInterpretedAsCallablesToRay()
  self.ray:send("value")

  lu.assertEquals(
    self.client:sent_payloads(),
    TestUtils.getSnapshot("ray_test_can_send_a_strings_that_might_be_interpreted_as_callables_to_ray")
  )
end
