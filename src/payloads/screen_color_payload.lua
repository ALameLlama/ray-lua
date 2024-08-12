-- https://github.com/spatie/ray/blob/main/src/Payloads/ScreenColorPayload.php

---@type Payload
local Payload = require("src.payloads.payload")

---@class ScreenColorPayload : Payload
---@field protected color string
local ScreenColorPayload = {}
ScreenColorPayload.__index = ScreenColorPayload

-- Use __call here to get a nicer constructor ScreenColorPayload() instead of ScreenColorPayload.new()
setmetatable(ScreenColorPayload, {
	__index = Payload,
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

---@param color string
---@return ScreenColorPayload
function ScreenColorPayload.new(color)
	local self = setmetatable({}, ScreenColorPayload)

	self.color = color

	return self
end

---@return string
function ScreenColorPayload:get_type()
	return "screen_color"
end

---@return table
function ScreenColorPayload:get_content()
	return {
		color = self.color,
	}
end

return ScreenColorPayload
