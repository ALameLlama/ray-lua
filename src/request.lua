-- https://github.com/spatie/ray/blob/main/src/Request.php

local json = require("cjson")
local Utils = require("ray.utils")

---@class Request
---@field protected uuid string
---@field protected payloads Payload[]
---@field protected meta table
local Request = {}
Request.__index = Request

-- Use __call here to get a nicer constructor Request() instead of Request.new()
setmetatable(Request, {
	__index = Request,
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

---@param uuid string
---@param payloads table
---@param meta table
function Request.new(uuid, payloads, meta)
	local self = setmetatable({}, Request)

	self.uuid = uuid
	self.payloads = payloads
	self.meta = meta or {}

	return self
end

---@return table
function Request:to_array()
	local payloads = Utils.array_map(function(payload)
		return payload:to_array()
	end, self.payloads)

	return {
		uuid = self.uuid,
		payloads = payloads,
		meta = self.meta,
	}
end

---@return string
function Request:to_json()
	return json.encode(self:to_array())
end

return Request
