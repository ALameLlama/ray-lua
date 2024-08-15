-- https://github.com/spatie/ray/blob/main/src/Payloads/ClearAllPayload.php

---@type Payload
local Payload = require("ray.payload")

---@class ClearAllPayload : Payload
local ClearAllPayload = {}
ClearAllPayload.__index = ClearAllPayload

-- Use __call here to get a nicer constructor ClearAllPayload() instead of ClearAllPayload.new()
setmetatable(ClearAllPayload, {
	__index = Payload,
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

---@return ClearAllPayload
function ClearAllPayload.new()
	local self = setmetatable({}, ClearAllPayload)

	return self
end

---@return string
function ClearAllPayload:get_type()
	return "clear_all"
end

return ClearAllPayload
