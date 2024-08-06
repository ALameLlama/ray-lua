-- https://github.com/spatie/ray/blob/main/src/Support/RateLimiter.php

---@class SupportRateLimiter
---@field protected max_calls integer?
---@field protected max_calls_per_second integer?
---@field protected cache_store table<string, integer>
---@field protected notified boolean
local RateLimiter = {}
RateLimiter.__index = RateLimiter

---@overload fun(): SupportRateLimiter
---@overload fun(max_calls: integer): SupportRateLimiter
---@overload fun(max_calls: integer, max_calls_per_second: integer): SupportRateLimiter
---@param max_calls integer?
---@param max_calls_per_second integer?
---@return SupportRateLimiter
function RateLimiter.new(max_calls, max_calls_per_second)
	local self = setmetatable({}, RateLimiter)

	self.max_calls = max_calls
	self.max_calls_per_second = max_calls_per_second
	self.cache_store = {}

	return self
end

---@return SupportRateLimiter
function RateLimiter:disabled()
	return RateLimiter.new()
end

---@return SupportRateLimiter
function RateLimiter:hit()
	self.cache_store:hit()

	return self
end

---@overload fun(): SupportRateLimiter
---@overload fun(max_calls: integer): SupportRateLimiter
---@param max_calls integer?
---@return SupportRateLimiter
function RateLimiter:max(max_calls)
	self.max_calls = max_calls

	return self
end

---@overload fun(): SupportRateLimiter
---@overload fun(max_calls_per_second: integer): SupportRateLimiter
---@param max_calls_per_second integer?
---@return SupportRateLimiter
function RateLimiter:per_second(max_calls_per_second)
	self.max_calls_per_second = max_calls_per_second

	return self
end

---@return boolean
function RateLimiter:is_max_reached()
	if self.max_calls == nil then
		return false
	end

	local reached = self.cache_store:count() >= self.max_calls

	if not reached then
		self.notified = false
	end

	return reached
end

---@return boolean
function RateLimiter:is_max_per_second_reached()
	if self.max_calls_per_second == nil then
		return false
	end

	local reached = self.cache_store:count_last_second() >= self.max_calls_per_second

	if not reached then
		self.notified = false
	end

	return reached
end

---@return SupportRateLimiter
function RateLimiter:clear()
	self.max_calls = nil
	self.max_calls_per_second = nil

	self.cache_store:clear()

	return self
end

function RateLimiter:is_notified()
	return self.notified
end

function RateLimiter:notify()
	self.notified = true
end

function RateLimiter:cache()
	return self.cache_store
end

return RateLimiter
