-- https://github.com/spatie/ray/blob/main/src/Origin/Origin.php

local json = require("cjson")
local md5 = require("md5")

---@type OriginHostname
local Hostname = require("ray.origin.hostname")

---@class Origin
---@field public file string?
---@field public line_number string?
---@field public hostname string?
local Origin = {}
Origin.__index = Origin

---@param file string?
---@param line_number string?
---@param hostname string?
function Origin.new(file, line_number, hostname)
  local self = setmetatable({}, Origin)

  self.file = file
  self.line_number = line_number
  self.hostname = hostname or Hostname:get()

  return self
end

---@return table
function Origin:to_array()
  return {
    file = self.file,
    line_number = self.line_number,
    hostname = self.hostname,
  }
end

---@return string
function Origin:fingerprint()
  return md5.sumhexa(json.encode(self:to_array()))
end

return Origin
