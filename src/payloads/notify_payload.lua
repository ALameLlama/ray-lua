-- https://github.com/spatie/ray/blob/1.41.2/src/Payloads/NotifyPayload.php

---@type Payload
local Payload = require("ray.payload")

---@class NotifyPayload : Payload
---@field protected text string
local NotifyPayload = {}
NotifyPayload.__index = NotifyPayload

-- Use __call here to get a nicer constructor NotifyPayload() instead of NotifyPayload.new()
setmetatable(NotifyPayload, {
	__index = Payload,
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

---@overload fun(values: table): NotifyPayload
---@param text string
---@return NotifyPayload
function NotifyPayload.new(text)
	local self = setmetatable({}, NotifyPayload)

	self.text = text

	return self
end

---@return string
function NotifyPayload:get_type()
	return "notify"
end

---@return table
function NotifyPayload:get_content()
	return {
		value = self.text,
	}
end

return NotifyPayload
