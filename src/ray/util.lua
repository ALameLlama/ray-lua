local uuid = require("uuid")

local http_request = require("http.request")
local cjson = require("cjson")

local debug = require("debug")

local inspect = require("inspect")

local config = {}
local config_file = loadfile("ray.lua")
if config_file then
	config = config_file()
end

local M = {}

M.generate_uuid = function()
	return uuid()
end

M.send = function(request)
	local request_payload = cjson.encode(request)
	local req = http_request.new_from_uri(
		string.format("%s://%s:%s", config.protocol or "http", config.hostname or "localhost", config.port or "23517")
	)

	req.headers:upsert(":method", "POST")
	req.headers:upsert("content-type", "application/json")

	req:set_body(request_payload)

	local headers, _ = req:go()
	if headers:get(":status") == "500" then
		print("Error: " .. headers:get(":status"))
	end
end

M.get_caller_info = function()
	local level = 2
	local last_ray_info = nil
	local info = debug.getinfo(level, "Sln")

	-- Iterate over the stack frames
	while info do
		-- Check if the function is defined in 'ray.lua'
		if info.source:match("/ray.lua$") then
			last_ray_info = info
		elseif last_ray_info then
			-- This is the first function after the last one in 'ray.lua'
			return {
				function_name = info.name or "unknown",
				file = info.short_src or "unknown",
				line_number = info.currentline or "unknown",
				hostname = config.hostname or "localhost",
			}
		end
		-- Go to the next stack frame
		level = level + 1
		info = debug.getinfo(level, "Sln")
	end

	return {
		function_name = "unknown",
		file = "unknown",
		line_number = "unknown",
		hostname = config.hostname or "localhost",
	}
end

return M
