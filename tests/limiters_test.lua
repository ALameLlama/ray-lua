local lu = require("luaunit")

---@type SupportLimiters
local Limiters = require("ray.support.limiters")

---@type Origin
local Origin = require("ray.origin")

TestLimiters = {}

function TestLimiters:setUp()
  self.limiters = Limiters.new()
end

function TestLimiters:testInitializesALimiterForAnOrigin()
  local init_results = {
    self.limiters:initializer(Origin.new("test.lua", 123), 5),
    self.limiters:initializer(Origin.new("testa.lua", 124), 8),
  }

  lu.assertEquals(init_results[1], { 0, 5 })
  lu.assertEquals(init_results[2], { 0, 8 })
end

function TestLimiters:testIncrementsALimiterCounterForAnOrigin()
  local origin = self:create_origin("test.lua", 123)

  local init_results = {
    self.limiters:increment(origin),
    self.limiters:increment(origin),
  }

  local counter, limit = self.limiters:increment(origin)

  lu.assertEquals(counter, 3)
end

---@overload fun(file: string, line_number: integer): Origin
---@overload fun(file: string, line_number: integer, initialize: boolean): Origin
---@overload fun(file: string, line_number: integer, initialize: boolean, limit: integer): Origin
---@param file string
---@param line_number integer
---@param initialize boolean
---@param limit integer
function TestLimiters:create_origin(file, line_number, initialize, limit)
  local result = Origin.new(file, line_number)

  -- Default value for initialize is true
  if initialize == nil then
    initialize = true
  end

  -- Default value for limit is 5
  if limit == nil then
    limit = 5
  end

  if initialize then
    self.limiters:initializer(result, limit)
  end

  return result
end

return TestLimiters
