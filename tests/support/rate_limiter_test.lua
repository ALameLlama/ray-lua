-- https://github.com/spatie/ray/blob/main/tests/Support/RateLimiterTest.php

local lu = require("luaunit")

---@type SupportRateLimiter
local RateLimiter = require("ray.support.rate_limiter")

TestRateLimiter = {}

function TestRateLimiter:testCanInitializeADisabledRateLimit()
  local rate_limiter = RateLimiter.disabled()

  lu.assertEquals(rate_limiter:is_max_reached(), false)
  lu.assertEquals(rate_limiter:is_max_per_second_reached(), false)
end

function TestRateLimiter:testCanUpdateTheMaxCalls()
  local rate_limiter = RateLimiter.disabled():clear():max(1)

  lu.assertEquals(rate_limiter:is_max_reached(), false)

  rate_limiter:hit()

  lu.assertEquals(rate_limiter:is_max_reached(), true)
end

function TestRateLimiter:testCanUpdateThePerSecondCalls()
  local rate_limiter = RateLimiter.disabled():clear():per_second(1)

  lu.assertEquals(rate_limiter:is_max_per_second_reached(), false)

  rate_limiter:hit()

  lu.assertEquals(rate_limiter:is_max_per_second_reached(), true)
end

function TestRateLimiter:testCanClearAllLimits()
  local rate_limiter = RateLimiter.disabled():max(1):per_second(1):hit()

  lu.assertEquals(rate_limiter:is_max_reached(), true)
  lu.assertEquals(rate_limiter:is_max_per_second_reached(), true)

  rate_limiter:clear()

  lu.assertEquals(rate_limiter:is_max_reached(), false)
  lu.assertEquals(rate_limiter:is_max_per_second_reached(), false)
end

return TestRateLimiter
