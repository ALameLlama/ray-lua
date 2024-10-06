---@diagnostic disable: duplicate-doc-field
-- https://github.com/spatie/ray/blob/1.41.2/src/Payloads/HtmlPayload.php

---@type Payload
local Payload = require("ray.payload")

---@class HtmlPayload : Payload
---@field protected html string
local HtmlPayload = {}
HtmlPayload.__index = HtmlPayload

-- Use __call here to get a nicer constructor HtmlPayload() instead of HtmlPayload.new()
setmetatable(HtmlPayload, {
	__index = Payload,
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

---@overload fun(values: table): HtmlPayload
---@param html string
---@return HtmlPayload
function HtmlPayload.new(html)
	local self = setmetatable({}, HtmlPayload)

	self.html = html

	return self
end

---@return string
function HtmlPayload:get_type()
	return "custom"
end

---@return table
function HtmlPayload:get_content()
	return {
		content = self.html,
		label = "HTML",
	}
end

return HtmlPayload
