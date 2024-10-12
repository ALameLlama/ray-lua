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

local ray, _ = unpack(require("ray"))

TestRay = {}

local function get_value_of_last_sent_content(content_key)
	local payload = TestRay.client:sent_payloads()

	if #payload == 0 then
		return nil
	end

	local last_payload = payload[#payload]

	return last_payload.payloads[1].content[content_key]
end

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

function TestRay:testTheRyFunctionAlsoWorks()
	Ray.fake_uuid = "fakeUuid"

	ray("a")

	lu.assertEquals(self.client:sent_payloads(), TestUtils.getSnapshot("ray_test_the_ray_function_also_works"))
end

function TestRay:testCanSendAnArrayToRay()
	self.ray:send({ a = 1, b = 2 })

	local dumped_value = get_value_of_last_sent_content("values")[1]

	lu.assertStrContains(dumped_value, "a = 1")
	lu.assertStrContains(dumped_value, "b = 2")
end

function TestRay:testCanSendMultipleThingsInOneGoToRay()
	self.ray:send("first", "second", "third")

	lu.assertEquals(
		self.client:sent_payloads(),
		TestUtils.getSnapshot("ray_test_can_send_multiple_things_in_one_go_to_ray")
	)
end

function TestRay:testCanSendAColorAndASize()
	self.ray:send("test", "test2").color("green").size("big")

	lu.assertEquals(self.client:sent_payloads(), TestUtils.getSnapshot("ray_test_can_send_a_color_and_a_size"))
end

function TestRay:testCanSendAScreenColor()
	self.ray.screen_green()

	lu.assertEquals(self.client:sent_payloads(), TestUtils.getSnapshot("ray_test_can_send_a_screen_color"))
end

function TestRay:testCanSendALaebl()
	self.ray:send("my value").label("my label")

	lu.assertEquals(self.client:sent_payloads(), TestUtils.getSnapshot("ray_test_can_send_a_label"))
end

function TestRay:testCanSendAHidePayloadToRay()
	self.ray:hide()

	lu.assertEquals(self.client:sent_payloads(), TestUtils.getSnapshot("ray_test_can_send_a_hide_payload_to_ray"))
end

function TestRay:testCanSendARemovePayloadToRay()
	self.ray:remove()

	lu.assertEquals(self.client:sent_payloads(), TestUtils.getSnapshot("ray_test_can_send_a_remove_payload_to_ray"))
end

function TestRay:testCanMeasureTimeAndMemory()
	local payload = {}
	self.ray.measure()

	payload = self.client:sent_payloads()
	lu.assertEquals(#payload, 1)

	lu.assertEquals(get_value_of_last_sent_content("is_new_timer"), true)
	lu.assertEquals(get_value_of_last_sent_content("total_time"), 0)
	lu.assertEquals(get_value_of_last_sent_content("max_memory_usage_during_total_time"), 0)
	lu.assertEquals(get_value_of_last_sent_content("time_since_last_call"), 0)
	lu.assertEquals(get_value_of_last_sent_content("max_memory_usage_since_last_call"), 0)

	os.execute("sleep 0.001")

	self.ray.measure()

	payload = self.client:sent_payloads()
	lu.assertEquals(#payload, 2)

	lu.assertEquals(get_value_of_last_sent_content("is_new_timer"), false)
	lu.assertNotEquals(get_value_of_last_sent_content("total_time"), 0)
	lu.assertNotEquals(get_value_of_last_sent_content("max_memory_usage_during_total_time"), 0)
	lu.assertNotEquals(get_value_of_last_sent_content("time_since_last_call"), 0)
	lu.assertNotEquals(get_value_of_last_sent_content("max_memory_usage_since_last_call"), 0)

	os.execute("sleep 0.001")

	self.ray.measure()

	payload = self.client:sent_payloads()
	lu.assertEquals(#payload, 3)
	lu.assertTrue(
		get_value_of_last_sent_content("total_time") >= get_value_of_last_sent_content("time_since_last_call")
	)

	self.ray.stop_time()

	self.ray.measure()

	payload = self.client:sent_payloads()
	-- print(inspect(payload))
	lu.assertEquals(#payload, 4)

	lu.assertEquals(get_value_of_last_sent_content("is_new_timer"), true)
	lu.assertEquals(get_value_of_last_sent_content("total_time"), 0)
	lu.assertEquals(get_value_of_last_sent_content("max_memory_usage_during_total_time"), 0)
	lu.assertEquals(get_value_of_last_sent_content("time_since_last_call"), 0)
	lu.assertEquals(get_value_of_last_sent_content("max_memory_usage_since_last_call"), 0)
end

function TestRay:testCanMeasureUsingMultipleTimers()
	self.ray.measure("my-timer")

	lu.assertEquals(get_value_of_last_sent_content("name"), "my-timer")
end

function TestRay:testCanMeasureAClosure()
	local closure = function()
		os.execute("sleep 0.001")
	end

	self.ray.measure(closure)

	local payload = self.client:sent_payloads()
	lu.assertEquals(#payload, 1)

	lu.assertNotEquals(get_value_of_last_sent_content("total_time"), 0)
	lu.assertNotEquals(get_value_of_last_sent_content("max_memory_usage_during_total_time"), 0)
	lu.assertNotEquals(get_value_of_last_sent_content("time_since_last_call"), 0)
	lu.assertNotEquals(get_value_of_last_sent_content("max_memory_usage_since_last_call"), 0)
end

function TestRay:testRemoveANamedStopwatchWhenStoppingTime()
	self.ray.measure("test-timer")

	lu.assertNotNil(self.ray.stop_watches["test-timer"])

	self.ray.stop_time("test-timer")

	lu.assertNil(self.ray.stop_watches["test-timer"])
end
