local lu = require("luaunit")
local ray = require("ray")
local messages = require("ray.messages")

TestRay = {} -- class

function TestRay:testRayFunctionWithNoArgs()
  local result = ray()
  lu.assertEquals(#result.request.payloads, 0)
end

function TestRay:testRayFunctionWithStringArg()
  local result = ray("Hello, String Arg")
  lu.assertEquals(#result.request.payloads, 1)
  lu.assertEquals(result.request.payloads[1].content.values, { "Hello, String Arg" })
  lu.assertEquals(result.request.payloads[1].content.label, messages.RayMessageType.Log)
end

function TestRay:testRayFunctionWithTableArg()
  local result = ray({ "Hello", "Table Arg" })
  lu.assertEquals(#result.request.payloads, 1)
  lu.assertEquals(result.request.payloads[1].content.values, { { "Hello", "Table Arg" } })
  lu.assertEquals(result.request.payloads[1].content.label, messages.RayMessageType.Log)
end

function TestRay:testRayFunctionWithMultipleArgs()
  local result = ray("Hello", "Multiple Args")
  lu.assertEquals(#result.request.payloads, 1)
  lu.assertEquals(result.request.payloads[1].content.values, { "Hello", "Multiple Args" })
  lu.assertEquals(result.request.payloads[1].content.label, messages.RayMessageType.Log)
end

function TestRay:testRayFunctionWithTableAndStringArgs()
  local result = ray({ "Hello", "Table Arg" }, "Hello, String Arg")
  lu.assertEquals(#result.request.payloads, 1)
  lu.assertEquals(result.request.payloads[1].content.label, messages.RayMessageType.Log)
  lu.assertEquals(result.request.payloads[1].content.values[1], { "Hello", "Table Arg" })
  lu.assertEquals(result.request.payloads[1].content.values[2], "Hello, String Arg")
end

function TestRay:testRayFunctionWithTableAndTableArgs()
  local result = ray({ "Hello", "Table Arg1" }, { "Hello", "Table Arg2" })
  lu.assertEquals(#result.request.payloads, 1)
  lu.assertEquals(result.request.payloads[1].content.label, messages.RayMessageType.Log)
  lu.assertEquals(result.request.payloads[1].content.values[1], { "Hello", "Table Arg1" })
  lu.assertEquals(result.request.payloads[1].content.values[2], { "Hello", "Table Arg2" })
end

os.exit(lu.LuaUnit.run())
