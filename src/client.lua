-- https://github.com/spatie/ray/blob/main/src/Client.php

local http = require("http.request")
local json = require("cjson")

---@class Client
---@field protected port_number integer
---@field protected host string
---@field protected fingerprint string
---@field protected cache table<string, [boolean, integer]>
local Client = {}
Client.__index = Client
Client.cache = {}

---@param port_number integer
---@param host string
---@return Client
function Client.new(port_number, host)
  local self = setmetatable({}, Client)

  self.port_number = port_number or 23517
  self.host = host or "localhost"
  self.fingerprint = self.host .. ":" .. self.port_number

  return self
end

---@return boolean
function Client:server_is_available()
  -- purge expired entries from the cache
  for k, v in pairs(self.cache) do
    if os.time() > v[2] then
      self.cache[k] = nil
    end
  end

  if not self.cache[self.fingerprint] then
    self:perform_availability_check()
  end

  return self.cache[self.fingerprint][1] or true
end

---@return boolean
function Client:perform_availability_check()
  local success = false
  local url = "http://" .. self.host .. ":" .. self.port_number .. "/_availability_check"
  local req = http.new_from_uri(url)
  req.headers:upsert(":method", "GET")

  local headers, _ = req:go()
  if headers:get(":status") == "404" then
    success = true
  end

  -- expire the cache entry after 30 sec
  local expires_at = os.time() + 30
  self.cache[self.fingerprint] = { success, expires_at }

  return success
end

---@param request table
function Client:send(request)
  if not self:server_is_available() then
    return
  end

  local url = "http://" .. self.host .. ":" .. self.port_number
  local req = http.new_from_uri(url)
  req.headers:upsert(":method", "POST")
  req.headers:upsert("content-type", "application/json")

  local request_payload = json.encode(request)
  req:set_body(request_payload)

  local headers, _ = req:go()
  if headers:get(":status") == "500" then
    print("Error: " .. headers:get(":status"))
  end
end

return Client
