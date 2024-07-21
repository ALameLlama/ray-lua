local M = {}

local uuid = require("uuid")

local http_request = require("http.request")
local cjson = require("cjson")

M.uuid = function()
  return uuid()
end

M.send = function(request)
  local request_payload = cjson.encode(request)
  local req = http_request.new_from_uri("http://localhost:23517")

  req.headers:upsert(":method", "POST")
  req.headers:upsert("content-type", "application/json")

  req:set_body(request_payload)

  local headers, _ = req:go()
  if headers:get(":status") == "500" then
    print("Error: " .. headers:get(":status"))
  end
end

return M
