-- https://github.com/spatie/ray/blob/main/src/Payloads/Payload.php

local json = require("cjson")

---@type OriginDefaultOriginFactory
local DefaultOriginFactory = require("ray.origin.default_origin_factory")

---@class Payload
---@field public remote_path string?
---@field public local_path string?
local Payload = {}
Payload.__index = Payload

---@return string
function Payload:get_type()
	-- This method should be overridden by subclasses
	error("Method 'get_type' must be implemented in subclass")
end

--TODO: test this to see if it works, Im not 100% sure about lua'a callstack source
---@param file_path string
---@return string
function Payload:replace_remote_path_with_local_path(file_path)
	if self.remote_path == nil or self.local_path == nil then
		return file_path
	end

	local pattern = "^" .. self.remote_path
	local replaced_path = string.gsub(file_path, pattern, self.local_path)

	return replaced_path
end

---@return table
function Payload:get_content()
	return {}
end

---@return table
function Payload:to_array()
	return {
		type = self:get_type(),
		content = self:get_content(),
		origin = self:get_origin():to_array(),
	}
end

---@return string
function Payload:to_json()
	return json.encode(self:to_array())
end

---@return Origin
function Payload:get_origin()
	-- In the PHP version, this method is public and can be set?
	--TODO: See if we need this instead of just returning the default origin factory
	local origin = DefaultOriginFactory:get_origin()

	origin.file = self:replace_remote_path_with_local_path(origin.file)

	return origin
end

return Payload
