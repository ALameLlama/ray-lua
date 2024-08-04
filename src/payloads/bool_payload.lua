-- https://github.com/spatie/ray/blob/main/src/Payloads/BoolPayload.php

---@type Payload
local Payload = require("ray.payload")

---@class BoolPayload : Payload
---@field protected value boolean
local BoolPayload = {}
BoolPayload.__index = BoolPayload

-- Use __call here to get a nicer constructor BoolPayload() instead of BoolPayload.new()
setmetatable(BoolPayload, {
  __index = Payload,
  __call = function(cls, ...)
    return cls.new(...)
  end,
})

---@param value boolean
---@return BoolPayload
function BoolPayload.new(value)
  local self = setmetatable({}, BoolPayload)

  self.value = value

  return self
end

---@return string
function BoolPayload:get_type()
  return "custom"
end

---@return table
function BoolPayload:get_content()
  return {
    content = self.value,
    label = "Boolean",
  }
end

return BoolPayload
