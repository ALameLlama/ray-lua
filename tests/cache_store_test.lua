local lu = require("luaunit")

local FakeClock = require("tests.helpers.fake_clock")

---@type SupportCacheStore
local CacheStore = require("ray.support.cache_store")

TestCacheStore = {}

function TestCacheStore:setUp()
  self.clock = FakeClock.new()
  self.store = CacheStore.new(self.clock)
end

function TestCacheStore:testCountPerSeconds()
  self.clock:freeze()

  self.store:hit():hit():hit()

  lu.assertEquals(self.store:count_last_second(), 3)

  self.clock:move_forward(1)

  lu.assertEquals(self.store:count_last_second(), 3)

  self.clock:move_forward(1)

  lu.assertEquals(self.store:count_last_second(), 0)
end

return TestCacheStore
