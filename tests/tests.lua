local lu = require("luaunit")

require("tests.support.cache_store_test")
require("tests.support.limiters_test")
require("tests.support.rate_limiter_test")

os.exit(lu.LuaUnit.run())
