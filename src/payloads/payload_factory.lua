-- https://github.com/spatie/ray/blob/main/src/PayloadFactory.php

---@type BoolPayload
local BoolPayload = require("ray.payload.bool_payload")

---@type NullPayload
local NullPayload = require("ray.payload.null_payload")

---@type LogPayload
local LogPayload = require("ray.payload.log_payload")

---@class PayloadFactory
---@field protected values table
---@field protected payload_finder function
local PayloadFactory = {}
PayloadFactory.__index = PayloadFactory

---@param arguments table
---@return table
function PayloadFactory.create_for_values(arguments)
	return PayloadFactory.new(arguments):get_payloads()
end

---@param callable function
function PayloadFactory:register_payload_finder(callable)
	self.payload_finder = callable
end

---@param values table
---@return PayloadFactory
function PayloadFactory.new(values)
	local self = setmetatable({}, PayloadFactory)

	self.values = values

	return self
end

---@return table
function PayloadFactory:get_payloads()
	local payloads = {}

	for _, value in ipairs(self.values) do
		table.insert(payloads, self:get_payload(value))
	end

	return payloads
end

---@protected
---@param value any
---@return Payload
function PayloadFactory:get_payload(value)
	if self.payload_finder then
		local payload = self.payload_finder(value)
		if payload then
			return payload
		end
	end

	if type(value) == "boolean" then
		return BoolPayload()
	end

	if value == nil then
		return NullPayload()
	end

	-- PHP uses Carbon a popular date-time library, idk if lua has something similar.
	--TODO: see if we want to add something like this in the future
	-- if type(value) == "table" and value.is_carbon then
	--   return CarbonPayload.new(value)
	-- end

	-- In the PHP version, the ArgumentConverter class is used to convert the value to a primitive value.
	-- Lua is a lot more of a simple language than PHP, so we can just use the value directly.
	-- local primitive_value = ArgumentConverter.convert_to_primitive(value)
	-- return LogPayload(primitive_value, value)

	return LogPayload(value, value)
end

return PayloadFactory
