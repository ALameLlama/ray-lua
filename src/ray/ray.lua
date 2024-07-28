local messages = require("ray.messages")
local util = require("ray.util")

-- Ray Payload Object
_RayPayload = {}
_RayPayload.__index = _RayPayload

--- @param uuid string
--- @param payloads table
--- @param meta table
function _RayPayload.new(uuid, payloads, meta)
	local self = setmetatable({}, _RayPayload)
	self.uuid = uuid
	self.payloads = payloads
	self.meta = meta
	return self
end

-- Ray Meta Object
_Meta = {}
_Meta.__index = _Meta

function _Meta.new()
	local self = setmetatable({}, _Meta)
	self.lua_version = _VERSION
	self.package_version = "v1.0.0"
	return self
end

-- Ray Content Object
_RayContent = {}
_RayContent.__index = _RayContent

--- @param type string
--- @param content table
--- @param origin table
function _RayContent.new(type, content, origin)
	local self = setmetatable({}, _RayContent)
	self.type = type
	self.content = content
	self.origin = origin
	return self
end

-- Ray Origin Object
_RayOrigin = {}
_RayOrigin.__index = _RayOrigin

function _RayOrigin.new()
	local self = setmetatable({}, _RayOrigin)
	local info = util.get_caller_info()

	self.function_name = info.function_name
	self.file = info.file
	self.line_number = info.line_number
	self.hostname = info.hostname
	return self
end

-- Ray Object
_Ray = {}
_Ray.__index = _Ray

function _Ray.new()
	local self = setmetatable({}, _Ray)
	self.request = _RayPayload.new(util.generate_uuid(), {}, _Meta.new())
	self.is_enabled = true
	return self
end

-- Ray functions
function _Ray:send()
	if not self.is_enabled then
		return
	end

	util.send(self.request)
end

function _Ray:die()
	os.exit()
end

--- @param values table
function _Ray:log(values)
	table.insert(
		self.request.payloads,
		_RayContent.new(messages.RayContentType.Log, messages.RayLog(values), _RayOrigin.new())
	)

	self:send()

	return self
end

--- @param values string
function _Ray:html(values)
	table.insert(
		self.request.payloads,
		_RayContent.new(messages.RayContentType.Custom, messages.RayHtml(values), _RayOrigin.new())
	)

	self:send()

	return self
end

--- @param values string
function _Ray:color(values)
	table.insert(
		self.request.payloads,
		_RayContent.new(messages.RayContentType.Color, messages.RayColor(values), _RayOrigin.new())
	)

	self:send()

	return self
end

-- Need to make sure we can call the color function with the correct spelling
--- @param values string
function _Ray:colour(values)
	table.insert(
		self.request.payloads,
		_RayContent.new(messages.RayContentType.Color, messages.RayColor(values), _RayOrigin.new())
	)

	self:send()

	return self
end

function _Ray:clear()
	table.insert(
		self.request.payloads,
		_RayContent.new(messages.RayContentType.ClearAll, messages.RayClearAll(), _RayOrigin.new())
	)

	self:send()

	return self
end

function Ray(...)
	local r = _Ray.new()
	local args = { ... }
	if #args > 0 then
		r:log(args)
	end
	return r
end

return Ray
