-- https://github.com/spatie/ray/blob/1.41.2/src/Payloads/RemovePayload.php

---@type Payload
local Payload = require("ray.payload")

---@class RemovePayload : Payload
local RemovePayload = {}
RemovePayload.__index = RemovePayload

-- Use __call here to get a nicer constructor RemovePayload() instead of RemovePayload.new()
setmetatable(RemovePayload, {
	__index = Payload,
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

---@return RemovePayload
function RemovePayload.new()
	local self = setmetatable({}, RemovePayload)

	return self
end

---@return string
function RemovePayload:get_type()
	return "remove"
end

return RemovePayload
