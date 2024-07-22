local uuid = require("uuid")

local http_request = require("http.request")
local cjson = require("cjson")

local debug = require("debug")

local config = {}
local config_file = loadfile("ray_config.lua")
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
    string.format("%s://%s:%s", config.protoco or "http", config.hostname or "localhost", config.port or "23517")
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
  local info = debug.getinfo(5, "Sln")

  -- TODO: see if there is a better way to get the current file?
  -- idk if this will blow up if you have files calling files
  -- Get the current working directory
  local cwd = io.popen("pwd"):read("*l")
  -- Combine the cwd with the relative path
  local file = cwd .. "/" .. info.short_src

  return {
    function_name = info.name or "unknown",
    file = file,
    line_number = info.currentline,
    hostname = "localhost",
  }
end

return M
