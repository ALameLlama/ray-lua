local lu = require("luaunit")

require("tests.cache_store_test")
require("tests.limiters_test")

os.exit(lu.LuaUnit.run())
