-- https://github.com/spatie/ray/blob/main/src/Payloads/ColorPayload.php

---@type Payload
local Payload = require("ray.payload")

---@class ColorPayload : Payload
---@field protected color string
local ColorPayload = {}
ColorPayload.__index = ColorPayload

-- Use __call here to get a nicer constructor ColorPayload() instead of ColorPayload.new()
setmetatable(ColorPayload, {
	__index = Payload,
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

---@param color string
---@return ColorPayload
function ColorPayload.new(color)
	local self = setmetatable({}, ColorPayload)

	self.color = color

	return self
end

---@return string
function ColorPayload:get_type()
	return "color"
end

---@return table
function ColorPayload:get_content()
	return {
		color = self.color,
	}
end

return ColorPayload
