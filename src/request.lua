-- https://github.com/spatie/ray/blob/main/src/Request.php

local json = require("cjson")

Request = {}
Request.__index = Request

---@param uuid string
---@param payloads table
---@param meta table
function Request:new(uuid, payloads, meta)
  local obj = {}
  setmetatable(obj, Request)

  obj.uuid = uuid
  obj.payloads = payloads
  obj.meta = meta or {}

  return obj
end

function Request:to_array()
  local payloads = {}

  for _, payload in ipairs(self.payloads) do
    table.insert(payloads, payload:to_array())
  end

  return {
    uuid = self.uuid,
    payloads = payloads,
    meta = self.meta,
  }
end

function Request:to_json()
  return json.encode(self:to_array())
end
