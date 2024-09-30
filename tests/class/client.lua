-- https://github.com/spatie/ray/blob/1.41.2/tests/TestClasses/FakeClient.php

---@type Client
local Client = require("ray.client")

---@class TestClassClient
---@field protected _sent_payloads table[]
---@field protected _sent_requests table[]
---@field protected port_number number
local TestClient = {}
TestClient.__index = TestClient

setmetatable(TestClient, {
	__index = Client,
})

---@return TestClassClient
function TestClient.new()
	local self = setmetatable({}, TestClient)

	self._sent_payloads = {}
	self._sent_requests = {}

	return self
end

---@return boolean
function TestClient.server_is_available()
	return true
end

---@param new_port_number number
---@return number
function TestClient:change_port_and_return_original(new_port_number)
	local result = self.port_number

	self.port_number = new_port_number

	return result
end

function TestClient:send(request)
	local request_properties = request:to_array()

	table.insert(self._sent_requests, request_properties)

	for _, payload in ipairs(request_properties.payloads) do
		payload.origin.file = self:convert_to_relative_filename(payload.origin.file)

		-- TODO: see if this is needed, this is laravel dump/dd stuff
		-- if payload.content.values and payload.content.values[1] then
		--   if type(payload.content.values[1]) ~= "boolean" then
		--     payload.content.values = string.gsub(payload.content.values, "sf-dump-%d+", "sf-dump-xxxxxxxxxx")
		--   end
		-- end

		if payload.content.frames then
			for _, frame in ipairs(payload.content.frames) do
				frame.file_name = self:convert_to_unix_path(self:convert_to_relative_filename(frame.file_name))
				frame.line_number = "xxx"
				frame.snippet = {}
			end
		end

		payload.origin.file = self:convert_to_unix_path(payload.origin.file)
		payload.origin.line_number = "xxx"
	end

	request_properties.meta = {}

	table.insert(self._sent_payloads, request_properties)
end

---@return table[]
function TestClient:sent_payloads()
	return self._sent_payloads
end

---@return table[]
function TestClient:sent_requests()
	return self._sent_requests
end

---@return TestClassClient
function TestClient:reset()
	self.sent_payloads = {}

	return self
end

-- TODO: see if this is needed
-- protected function baseDirectory(): string
-- {
--     return str_replace("/tests/TestClasses", '', __DIR__);
-- }

function TestClient:convert_to_unix_path(path)
	path = string.gsub(path, "D:\\a\\ray\\ray", "")

	return string.gsub(path, "\\", "/")
end

function TestClient:convert_to_relative_filename(filename)
	return string.gsub(filename, "/tests/TestClasses", "")
end

return TestClient
