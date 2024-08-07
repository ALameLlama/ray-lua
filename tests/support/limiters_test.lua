-- https://github.com/spatie/ray/blob/main/tests/Support/LimitersTest.php

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

  self.limiters:increment(origin)
  self.limiters:increment(origin)

  local counter, _ = unpack(self.limiters:increment(origin))

  lu.assertEquals(counter, 3)
end

function TestLimiters:testDoesNotIncrementALimiterCounterForAnUninitializedOrigin()
  local origin = Origin.new("test.lua", 456)

  local increment_result = self.limiters:increment(origin)

  lu.assertEquals(increment_result, { false, false })
end

function TestLimiters:testDeterminesIfAPayloadCanBeSentForAGivenOrigin()
  local origin = self:create_origin("test.lua", 123, true, 2)

  self.limiters:increment(origin)
  lu.assertEquals(self.limiters:can_send_payload(origin), true)

  self.limiters:increment(origin)
  lu.assertEquals(self.limiters:can_send_payload(origin), false)
end

---@private
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
