local lu = require("luaunit")
local ray = require("ray")

TestRay = {} -- class

function TestRay:testRayFunctionWithNoArgs()
  local result = ray()
  lu.assertEquals(#result.request.payloads, 0)
end

function TestRay:testRayFunctionWithOneArg()
  local result = ray():log({ "Hello, Ray Macro" })
  lu.assertEquals(#result.request.payloads, 1)
end

function TestRay:testRayFunctionWithMultipleArgs()
  local result = ray():log({ "Hello", "Ray Macro" })
  lu.assertEquals(#result.request.payloads, 1)
end

os.exit(lu.LuaUnit.run())
