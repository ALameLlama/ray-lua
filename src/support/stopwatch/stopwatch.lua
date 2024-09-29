-- https://github.com/symfony/symfony/blob/7.2/src/Symfony/Component/Stopwatch/Stopwatch.php

---@class SupportStopwatchSection
local Section = require("ray.support.stopwatch.section")

---@class SupportStopwatch
---@field private sections table<string, SupportStopwatchSection>
---@field private active_sections table<string, SupportStopwatchSection>
---@field private more_precision boolean
local Stopwatch = {}
Stopwatch.__index = Stopwatch

Stopwatch.ROOT = "__root__"

function Stopwatch.new(more_precision)
	local self = setmetatable({}, Stopwatch)

	self.more_precision = more_precision or false
	self:reset()

	return self
end

function Stopwatch:get_sections()
	return self.sections
end

function Stopwatch:open_section(id)
	local current = self.active_sections[#self.active_sections]

	if id ~= nil and current:get(id) == nil then
		error(string.format('The section "%s" has been started at another level and cannot be opened.', id))
	end

	self:start("__section__.child", "section")
	table.insert(self.active_sections, current:open(id))
	self:start("__section__")
end

function Stopwatch:stop_section(id)
	self:stop("__section__")

	if #self.active_sections == 1 then
		error("There is no started section to stop.")
	end

	self.sections[id] = table.remove(self.active_sections):set_id(id)
	self:stop("__section__.child")
end

function Stopwatch:start(name, category)
	return self.active_sections[#self.active_sections]:start_event(name, category)
end

function Stopwatch:is_started(name)
	return self.active_sections[#self.active_sections]:is_event_started(name)
end

function Stopwatch:stop(name)
	return self.active_sections[#self.active_sections]:stop_event(name)
end

function Stopwatch:lap(name)
	return self.active_sections[#self.active_sections]:stop_event(name):start()
end

function Stopwatch:get_event(name)
	return self.active_sections[#self.active_sections]:get_event(name)
end

function Stopwatch:get_section_events(id)
	return self.sections[id]:get_events() or {}
end

function Stopwatch:get_root_section_events()
	return self.sections[Stopwatch.ROOT]:get_events() or {}
end

function Stopwatch:reset()
	self.sections = { [Stopwatch.ROOT] = Section.new(nil, self.more_precision) }
	self.active_sections = { self.sections[Stopwatch.ROOT] }
end

return Stopwatch
