-- https://github.com/spatie/ray/blob/1.41.2/src/Payloads/LogPayload.php
-- In the PHP implementation, they have some more type conversion logic and clipboard logic
-- TODO: look into if we really need it

---@type Payload
local Payload = require("ray.payload")

---@class LogPayload : Payload
---@field protected values table
---@field protected meta table
local LogPayload = {}
LogPayload.__index = LogPayload

-- Use __call here to get a nicer constructor LogPayload() instead of LogPayload.new()
setmetatable(LogPayload, {
	__index = Payload,
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

---@overload fun(values: table): LogPayload
---@param values table
---@param meta table
---@return LogPayload
function LogPayload.new(values, meta)
	local self = setmetatable({}, LogPayload)

	if type(values) ~= "table" then
		values = { values }
	end

	self.values = values

	if meta and type(meta) ~= "table" then
		meta = { meta }
	end

	self.meta = meta or {}

	return self
end

---@return string
function LogPayload:get_type()
	return "log"
end

---@return table
function LogPayload:get_content()
	return {
		values = self.values,
		meta = self.meta,
	}
end

return LogPayload
