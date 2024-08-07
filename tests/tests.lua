local lu = require("luaunit")

-- Support Tests
require("tests.support.cache_store_test")
require("tests.support.limiters_test")
require("tests.support.rate_limiter_test")
-- TODO: Support PlainTestDumper

require("tests.ray_test")
require("tests.settings_test")

os.exit(lu.LuaUnit.run())
