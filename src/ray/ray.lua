local messages = require("ray.messages")
local util = require("ray.util")

-- Ray Payload Object
_RayPayload = {}
_RayPayload.__index = _RayPayload

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

function _RayOrigin.new(function_name, file, line_number, hostname)
  local self = setmetatable({}, _RayOrigin)
  -- self.function_name = function_name
  -- self.file = file
  -- self.line_number = line_number
  -- self.hostname = hostname

  self.function_name = "lua"
  self.file = ""      -- replace with actual file
  self.line_number = 0 -- replace with actual line number
  self.hostname = "localhost"
  return self
end

-- Ray Object
_Ray = {}
_Ray.__index = _Ray

function _Ray.new()
  local self = setmetatable({}, _Ray)
  self.request = _RayPayload.new(util.uuid(), {}, _Meta.new())
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

function _Ray:log(values)
  table.insert(
    self.request.payloads,
    _RayContent.new(messages.RayContentType.Log, messages.RayLog(values), _RayOrigin.new())
  )

  self:send()

  return self
end

function _Ray:html(values)
  table.insert(
    self.request.payloads,
    _RayContent.new(messages.RayContentType.Custom, messages.RayHtml(values), _RayOrigin.new())
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
