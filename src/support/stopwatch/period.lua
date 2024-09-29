-- https://github.com/symfony/symfony/blob/7.2/src/Symfony/Component/Stopwatch/StopwatchPeriod.php

---@class SupportStopwatchPeriod
---@field start_time number
---@field end_time number
---@field memory number
local Period = {}
Period.__index = Period

---@param start_time number
---@param end_time number
---@param more_precision boolean
---@return SupportStopwatchPeriod
function Period.new(start_time, end_time, more_precision)
  local self = setmetatable({}, Period)

  self.start_time = more_precision and tonumber(start_time) or math.floor(start_time)
  self.end_time = more_precision and tonumber(end_time) or math.floor(end_time)
  self.memory = collectgarbage("count") * 1024 -- Lua's memory usage in bytes

  return self
end

---@return number
function Period:get_start_time()
  return self.start_time
end

---@return number
function Period:get_end_time()
  return self.end_time
end

---@return number
function Period:get_duration()
  return self.end_time - self.start_time
end

---@return number
function Period:get_memory()
  return self.memory
end

---@return string
function Period:__tostring()
  return string.format("%.2f Mi_b - %d ms", self:get_memory() / 1024 / 1024, self:get_duration())
end

return Period
