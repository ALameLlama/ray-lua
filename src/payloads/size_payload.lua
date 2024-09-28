-- https://github.com/spatie/ray/blob/1.41.2/src/Payloads/SizePayload.php

---@type Payload
local Payload = require("ray.payload")

---@class SizePayload : Payload
---@field protected size string
local SizePayload = {}
SizePayload.__index = SizePayload

-- Use __call here to get a nicer constructor SizePayload() instead of SizePayload.new()
setmetatable(SizePayload, {
	__index = Payload,
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

---@param size string
---@return SizePayload
function SizePayload.new(size)
	local self = setmetatable({}, SizePayload)

	self.size = size

	return self
end

---@return string
function SizePayload:get_type()
	return "size"
end

---@return table
function SizePayload:get_content()
	return {
		size = self.size,
	}
end

return SizePayload
