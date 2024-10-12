-- https://github.com/spatie/ray/blob/1.41.2/src/Payloads/MeasurePayload.php

---@type Payload
local Payload = require("ray.payload")

---@class MeasurePayload : Payload
---@field protected name string
---@field protected is_new_timer boolean
---@field protected total_time number
---@field protected max_memory_usage_during_total_time number
---@field protected time_since_last_call number
---@field protected max_memory_usage_since_last_call number
local MeasurePayload = {}
MeasurePayload.__index = MeasurePayload

-- Use __call here to get a nicer constructor MeasurePayload() instead of MeasurePayload.new()
setmetatable(MeasurePayload, {
	__index = Payload,
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

---@param name string
---@param stopwatch_event SupportStopwatchEvent
---@return Payload
function MeasurePayload.new(name, stopwatch_event)
	local self = setmetatable({}, MeasurePayload)

	self.name = name
	self.is_new_timer = false
	self.time_since_last_call = 0
	self.max_memory_usage_since_last_call = 0

	self.total_time = stopwatch_event:get_duration()
	self.max_memory_usage_during_total_time = stopwatch_event:get_memory()

	local periods = stopwatch_event:get_periods()

	if #periods > 0 then
		local last_period = periods[#periods]

		if last_period then
			self.time_since_last_call = last_period:get_duration()
			self.max_memory_usage_since_last_call = last_period:get_memory()
		end
	end

	return self
end

---@return MeasurePayload
function MeasurePayload:concerns_new_timer()
	self.is_new_timer = true
	self.total_time = 0
	self.max_memory_usage_during_total_time = 0
	self.time_since_last_call = 0
	self.max_memory_usage_since_last_call = 0

	return self
end

---@return string
function MeasurePayload:get_type()
	return "measure"
end

---@return table
function MeasurePayload:get_content()
	return {
		name = self.name,
		is_new_timer = self.is_new_timer,
		total_time = self.total_time,
		max_memory_usage_during_total_time = self.max_memory_usage_during_total_time,
		time_since_last_call = self.time_since_last_call,
		max_memory_usage_since_last_call = self.max_memory_usage_since_last_call,
	}
end

return MeasurePayload
