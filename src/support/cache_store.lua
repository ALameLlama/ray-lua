-- https://github.com/spatie/ray/blob/main/src/Support/CacheStore.php

---@type SupportClock
local Clock = require("ray.support.clock")

---@class SupportCacheStore
---@field protected store table<integer>
---@field protected clock SupportClock
local CacheStore = {}
CacheStore.__index = CacheStore
CacheStore.store = {}

---@return SupportCacheStore
function CacheStore.new()
	local self = setmetatable({}, CacheStore)

	self.clock = Clock

	return self
end

---@return SupportCacheStore
function CacheStore:hit()
	table.insert(self.store, self.clock:now())

	return self
end

---@return SupportCacheStore
function CacheStore:clear()
	self.store = {}

	return self
end

---@return integer
function CacheStore:count()
	return #self.store
end

---@return integer
function CacheStore:count_last_second()
	local amount = 0

	local now = self.clock:now()
	local last_second = now - 1

	for _, timestamp in pairs(self.store) do
		if self:is_between(timestamp, last_second, now) then
			amount = amount + 1
		end
	end

	return amount
end

---@protected
---@param timestamp integer
---@param start integer
---@param finish integer
---@return boolean
function CacheStore:is_between(timestamp, start, finish)
	return timestamp >= start and timestamp <= finish
end
