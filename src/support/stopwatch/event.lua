-- https://github.com/symfony/symfony/blob/7.2/src/Symfony/Component/Stopwatch/StopwatchEvent.php

---@type SupportStopwatchPeriod
local StopwatchPeriod = require("ray.support.stopwatch.period")

---@class SupportStopwatchEvent
---@field periods SupportStopwatchPeriod[]
---@field origin number
---@field category string
---@field more_precision boolean
---@field name string
---@field started number[]
local Event = {}
Event.__index = Event

---@param origin number
---@param category string
---@param more_precision boolean
---@param name string
---@return SupportStopwatchEvent
function Event.new(origin, category, more_precision, name)
  local self = setmetatable({}, Event)

  self.periods = {}
  self.origin = self.format_time(origin)
  self.category = category or "default"
  self.more_precision = more_precision or false
  self.name = name or "default"
  self.started = {}

  return self
end

---@return string
function Event:get_category()
  return self.category
end

---@return number
function Event:get_origin()
  return self.origin
end

---@return SupportStopwatchEvent
function Event:start()
  table.insert(self.started, self:get_now())

  return self
end

---@return SupportStopwatchEvent
function Event:stop()
  if #self.started == 0 then
    error("stop() called but start() has not been called before.")
  end

  table.insert(self.periods, StopwatchPeriod.new(table.remove(self.started), self:get_now(), self.more_precision))

  return self
end

---@return boolean
function Event:is_started()
  return #self.started > 0
end

---@return SupportStopwatchEvent
function Event:lap()
  return self:stop():start()
end

function Event:ensure_stopped()
  while #self.started > 0 do
    self:stop()
  end
end

---@return SupportStopwatchPeriod[]
function Event:get_periods()
  return self.periods
end

---@return SupportStopwatchPeriod?
function Event:get_last_period()
  if #self.periods == 0 then
    return nil
  end

  return self.periods[#self.periods]
end

---@return number
function Event:get_start_time()
  if #self.periods > 0 then
    return self.periods[1]:get_start_time()
  end

  if #self.started > 0 then
    return self.started[1]
  end

  return 0
end

---@return number
function Event:get_end_time()
  if #self.periods > 0 then
    return self.periods[#self.periods]:get_end_time()
  end

  return 0
end

---@return number
function Event:get_duration()
  local periods = self.periods
  local left = #self.started

  for i = left - 1, 1, -1 do
    table.insert(periods, StopwatchPeriod.new(self.started[i], self:get_now(), self.more_precision))
  end

  local total = 0
  for _, period in ipairs(periods) do
    total = total + period:get_duration()
  end

  return total
end

---@return number
function Event:get_memory()
  local memory = 0

  for _, period in ipairs(self.periods) do
    if period:get_memory() > memory then
      memory = period:get_memory()
    end
  end

  return memory
end

---@return number
function Event:get_now()
  return self.format_time(os.time() * 1000 - self.origin)
end

---@param time number
---@return number
function Event.format_time(time)
  return math.floor(time * 10 + 0.5) / 10
end

---@return string
function Event:get_name()
  return self.name
end

---@return string
function Event:__tostring()
  return string.format(
    "%s/%s: %.2f Mi_b - %d ms",
    self:get_category(),
    self:get_name(),
    self:get_memory() / 1024 / 1024,
    self:get_duration()
  )
end

return Event
