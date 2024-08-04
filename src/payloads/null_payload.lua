-- https://github.com/spatie/ray/blob/main/src/Payloads/NullPayload.php

---@type Payload
local Payload = require("ray.payload")

---@class NullPayload : Payload
---@field protected value boolean
local NullPayload = {}
NullPayload.__index = NullPayload

-- Use __call here to get a nicer constructor NullPayload() instead of NullPayload.new()
setmetatable(NullPayload, {
  __index = Payload,
  __call = function(cls, ...)
    return cls.new(...)
  end,
})

function NullPayload.new()
  local self = setmetatable({}, NullPayload)

  return self
end

function NullPayload:get_type()
  return "custom"
end

function NullPayload:get_content()
  return {
    content = nil,
    label = "Null",
  }
end

return NullPayload
