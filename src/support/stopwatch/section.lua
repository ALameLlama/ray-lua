-- https://github.com/symfony/symfony/blob/7.2/src/Symfony/Component/Stopwatch/Section.php

---@type SupportStopwatchEvent
local StopwatchEvent = require("ray.support.stopwatch.event")

---@class SupportStopwatchSection
---@field events table<string, SupportStopwatchEvent>
---@field id string
---@field children table<string, SupportStopwatchSection>
---@field origin number?
---@field more_precision boolean
local Section = {}
Section.__index = Section

---@param origin number?
---@param more_precision boolean
---@return SupportStopwatchSection
function Section.new(origin, more_precision)
  local self = setmetatable({}, Section)

  self.events = {}
  self.id = nil
  self.children = {}
  self.origin = origin or nil
  self.more_precision = more_precision or false

  return self
end

function Section:get(id)
  for _, child in ipairs(self.children) do
    if id == child:get_id() then
      return child
    end
  end

  return nil
end

function Section:open(id)
  local session

  if id == nil or self:get(id) == nil then
    session = Section.new(os.time() * 1000, self.more_precision)
    table.insert(self.children, session)
  else
    session = self:get(id)
  end

  return session
end

function Section:get_id()
  return self.id
end

function Section:set_id(id)
  self.id = id

  return self
end

function Section:start_event(name, category)
  if self.events[name] == nil then
    self.events[name] = StopwatchEvent.new(self.origin or os.time() * 1000, category, self.more_precision, name)
  end

  return self.events[name]:start()
end

function Section:is_event_started(name)
  return self.events[name] ~= nil and self.events[name]:is_started()
end

function Section:stop_event(name)
  if self.events[name] == nil then
    error(string.format('Event "%s" is not started.', name))
  end

  return self.events[name]:stop()
end

function Section:lap(name)
  return self:stop_event(name):start()
end

function Section:get_event(name)
  if self.events[name] == nil then
    error(string.format('Event "%s" is not known.', name))
  end

  return self.events[name]
end

function Section:get_events()
  return self.events
end

return Section
