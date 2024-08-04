-- https://github.com/spatie/ray/blob/main/src/Request.php

local json = require("cjson")

--TODO: Implement payload class

---@class Request
---@field protected uuid string
---@field protected payloads table
---@field protected meta table
local Request = {}
Request.__index = Request

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
	local payloads = {}

	for _, payload in ipairs(self.payloads) do
		table.insert(payloads, payload:to_array())
	end

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
