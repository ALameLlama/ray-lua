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

-- WARN: This doesn't work as expected. LuaUnit does things interally that breaks this.
-- function TestRay:testRayFunctionOriginData()
-- 	local result = ray("Hello, Origin")
-- 	lu.assertEquals(#result.request.payloads, 1)
-- 	lu.assertEquals(result.request.payloads[1].origin.file, "src/ray/test.lua")
-- 	lu.assertEquals(result.request.payloads[1].origin.function_name, "testRayFunctionOriginData")
-- 	lu.assertEquals(result.request.payloads[1].origin.hostname, "localhost")
-- 	lu.assertEquals(result.request.payloads[1].origin.line_number, 47)
-- end

function TestRay:testRayFunctionWithLog()
	local result = ray():log({ "Hello, Log" })
	lu.assertEquals(#result.request.payloads, 1)
	lu.assertEquals(result.request.payloads[1].content.values, { "Hello, Log" })
	lu.assertEquals(result.request.payloads[1].content.label, messages.RayMessageType.Log)
end

function TestRay:testRayFunctionWithHtml()
	local result = ray():html("<div>Hello <strong>Html</strong></div>")
	lu.assertEquals(#result.request.payloads, 1)
	lu.assertEquals(result.request.payloads[1].content.content, "<div>Hello <strong>Html</strong></div>")
	lu.assertEquals(result.request.payloads[1].content.label, messages.RayMessageType.HTML)
end

os.exit(lu.LuaUnit.run())
