-- https://github.com/spatie/ray/blob/main/src/Payloads/HidePayload.php

---@type Payload
local Payload = require("ray.payload")

---@class HidePayload : Payload
local HidePayload = {}
HidePayload.__index = HidePayload

-- Use __call here to get a nicer constructor HidePayload() instead of HidePayload.new()
setmetatable(HidePayload, {
	__index = Payload,
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

---@return HidePayload
function HidePayload.new()
	local self = setmetatable({}, HidePayload)

	return self
end

---@return string
function HidePayload:get_type()
	return "hide"
end

return HidePayload
