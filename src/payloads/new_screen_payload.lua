-- https://github.com/spatie/ray/blob/1.41.2/src/Payloads/NewScreenPayload.php

---@type Payload
local Payload = require("ray.payload")

---@class NewScreenPayload : Payload
---@field protected name string
local NewScreenPayload = {}
NewScreenPayload.__index = NewScreenPayload

-- Use __call here to get a nicer constructor NewScreenPayload() instead of NewScreenPayload.new()
setmetatable(NewScreenPayload, {
	__index = Payload,
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

---@param name string
---@return NewScreenPayload
function NewScreenPayload.new(name)
	local self = setmetatable({}, NewScreenPayload)

	self.name = name

	return self
end

---@return string
function NewScreenPayload:get_type()
	return "new_screen"
end

---@return table
function NewScreenPayload:get_content()
	return {
		name = self.name,
	}
end

return NewScreenPayload
