-- https://github.com/spatie/ray/blob/main/src/Support/Counters.php

require("ray")

---@class SupportCounters
---@field protected counters table<string, [Ray, integer]>
local Counters = {}
Counters.__index = Counters
Counters.counters = {}

---@param key string
---@return table
function Counters:increment(key)
	if self.counters[key] == nil then
		self.counters[key] = { ray(), 0 }
	end

	local ray, times = unpack(self.counters[key])
	local new_times = times + 1

	self.counters[key] = { ray, new_times }

	return { ray, new_times }
end

---@param key string
---@return integer
function Counters:get(key)
	if self.counters[key] == nil then
		return 0
	end

	return self.counters[key][2]
end

function Counters:clear()
	self.counters = {}
end

---@param name string
---@param ray Ray
function Counters:set_ray(name, ray)
	if self.counters[name] == nil then
		self.counters[name] = { ray, 0 }
	end

	self.counters[name][1] = ray
end

return Counters
