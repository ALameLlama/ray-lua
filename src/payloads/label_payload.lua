-- https://github.com/spatie/ray/blob/main/src/Payloads/LabelPayload.php

---@type Payload
local Payload = require("ray.payload")

---@class LabelPayload : Payload
---@field protected label string
local LabelPayload = {}
LabelPayload.__index = LabelPayload

-- Use __call here to get a nicer constructor LabelPayload() instead of LabelPayload.new()
setmetatable(LabelPayload, {
	__index = Payload,
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

---@param label string
---@return LabelPayload
function LabelPayload.new(label)
	local self = setmetatable({}, LabelPayload)

	self.label = label

	return self
end

---@return string
function LabelPayload:get_type()
	return "label"
end

---@return table
function LabelPayload:get_content()
	return {
		label = self.label,
	}
end

return LabelPayload
