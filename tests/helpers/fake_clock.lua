---@class FakeClock
local FakeClock = {}
FakeClock.__index = FakeClock

function FakeClock.new()
  local self = {
    time = 0,
    frozen = false,
  }

  setmetatable(self, FakeClock)

  return self
end

function FakeClock:now()
  return self.time
end

function FakeClock:freeze()
  self.frozen = true
end

function FakeClock:move_forward(seconds)
  if self.frozen then
    self.time = self.time + seconds
  end
end

function FakeClock:get_time()
  return self.time
end

return FakeClock
