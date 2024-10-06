-- https://github.com/spatie/ray/blob/1.41.2/src/PayloadFactory.php

local Utils = require("ray.utils")

local BoolPayload = require("ray.payload.bool_payload")
local NullPayload = require("ray.payload.null_payload")
local LogPayload = require("ray.payload.log_payload")
local HtmlPayload = require("ray.payload.html_payload")

---@type ArgumentConverter
local ArgumentConverter = require("ray.argument_converter")

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
	return Utils.array_map(function(value)
		return self:get_payload(value)
	end, self.values)
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

	-- PHP uses Carbon, idk if lua has something similar.
	--TODO: see if we want to add something like this in the future
	-- if type(value) == "table" and value.is_carbon then
	--   return CarbonPayload.new(value)
	-- end

	local primitive_value = ArgumentConverter.convert_to_primitive(value)

	if primitive_value.is_html then
		return HtmlPayload(primitive_value.value, value)
	end

	return LogPayload(primitive_value.value, value)
end

return PayloadFactory
