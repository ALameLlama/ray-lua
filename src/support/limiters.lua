-- https://github.com/spatie/ray/blob/main/src/Support/Limiters.php

---@class SupportLimiters
---@field protected limiters table<string, [integer, integer]>
local Limiters = {}
Limiters.__index = Limiters
Limiters.limiters = {}

---@param origin Origin
---@param limit integer
---@return table
function Limiters:initializer(origin, limit)
	local name = origin.fingerprint

	if self.limiters[name] == nil then
		self.limiters[name] = { 0, limit }
	end

	return self.limiters[name]
end

---@param origin Origin
---@return [integer, integer]
function Limiters:increment(origin)
	local name = origin.fingerprint

	if self.limiters[name] == nil then
		return { false, false }
	end

	local times, limit = unpack(self.limiters[name])
	local new_times = times + 1

	self.limiters[name] = { new_times, limit }

	return { new_times, limit }
end

---@param origin Origin
---@return boolean
function Limiters:can_send_payload(origin)
	local name = origin.fingerprint

	if self.limiters[name] == nil then
		return true
	end

	local times, limit = unpack(self.limiters[name])

	return times < limit or limit <= 0
end

return Limiters
