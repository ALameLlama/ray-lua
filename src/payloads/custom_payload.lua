-- https://github.com/spatie/ray/blob/main/src/Payloads/CustomPayload.php

---@type Payload
local Payload = require("src.payloads.payload")

---@class CustomPayload : Payload
---@field protected content string
---@field protected label string
local CustomPayload = {}
CustomPayload.__index = CustomPayload

-- Use __call here to get a nicer constructor CustomPayload() instead of CustomPayload.new()
setmetatable(CustomPayload, {
	__index = Payload,
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

---@overload fun(content: string): CustomPayload
---@param content string
---@param label string
---@return CustomPayload
function CustomPayload.new(content, label)
	local self = setmetatable({}, CustomPayload)

	self.content = content
	self.label = label or ""

	return self
end

---@return string
function CustomPayload:get_type()
	return "custom"
end

---@return table
function CustomPayload:get_content()
	return {
		content = self.content,
		label = self.label,
	}
end

return CustomPayload
