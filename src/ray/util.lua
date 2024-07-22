local uuid = require("uuid")

local http_request = require("http.request")
local cjson = require("cjson")

local debug = require("debug")

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
	local info = debug.getinfo(level, "Sln")

	-- Iterate over the stack frames
	while info do
		-- Check if the function is not defined in the 'ray' or 'util' modules
		if not info.source:match("/ray.lua$") and not info.source:match("/util.lua$") then
			local cwd = io.popen("pwd"):read("*l")
			local file = cwd .. "/" .. info.source:sub(2)
			return {
				function_name = info.name or "unknown",
				file = file,
				line_number = info.currentline,
				hostname = config.hostname or "localhost",
			}
		end
		-- Go to the next stack frame
		level = level + 1
		info = debug.getinfo(level, "Sln")
	end

	-- If no function was found that is not in 'ray' or 'util', return nil
	return nil
end

return M
