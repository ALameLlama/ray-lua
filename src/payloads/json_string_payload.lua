-- https://github.com/spatie/ray/blob/main/src/Payloads/JsonStringPayload.php

local json = require("cjson")

---@type Payload
local Payload = require("ray.payload")

---@class JsonStringPayload : Payload
---@field protected value string
local JsonStringPayload = {}
JsonStringPayload.__index = JsonStringPayload

-- Use __call here to get a nicer constructor JsonStringPayload() instead of JsonStringPayload.new()
setmetatable(JsonStringPayload, {
	__index = Payload,
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

---@overload fun(values: table): JsonStringPayload
---@param value string
---@return JsonStringPayload
function JsonStringPayload.new(value)
	local self = setmetatable({}, JsonStringPayload)

	self.value = value

	return self
end

---@return string
function JsonStringPayload:get_type()
	return "json_string"
end

---@return table
function JsonStringPayload:get_content()
	return {
		value = json.encode(self.value),
	}
end

return JsonStringPayload
