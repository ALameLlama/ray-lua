-- https://github.com/spatie/ray/blob/main/src/Origin/DefaultOriginFactory.php

-- We use this like an interface in PHP
---@type OriginFactory
local OriginFactory = require("ray.origin.origin_factory")

---@type Origin
local Origin = require("ray.origin")

---@type OriginHostname
local Hostname = require("ray.origin.hostname")

---@class OriginDefaultOriginFactory
local DefaultOriginFactory = {}
DefaultOriginFactory.__index = DefaultOriginFactory

setmetatable(DefaultOriginFactory, OriginFactory)

---@return Origin
function DefaultOriginFactory:get_origin()
  local frame = self:get_frame()

  return Origin.new(frame and frame.file or nil, frame and frame.line or nil, Hostname:get())
end

---@protected
function DefaultOriginFactory:get_frame()
  local frames = self:get_all_frames()

  local index_of_ray = self:get_index_of_ray_frame(frames)

  if not index_of_ray then
    return nil
  end

  -- Return +1 so we can find the first line before the ray call
  return frames[index_of_ray + 1] or nil
end

-- Spatie has a custom backtrace here.
-- We just use the default Lua debug library to get the frames
---@protected
---@return table
function DefaultOriginFactory:get_all_frames()
  local level = 1
  local frames = {}

  while true do
    local info = debug.getinfo(level, "Sln")

    if not info then
      break
    end

    table.insert(frames, info)

    level = level + 1
  end

  --TODO: see if we need to reverse the frames?
  -- It's done like this in the PHP version
  -- table.insert(frames, 1, info)
  return frames
end

---@protected
---@param frames table
---@return number?
function DefaultOriginFactory:get_index_of_ray_frame(frames)
  for index, frame in ipairs(frames) do
    -- This is the best way i can think of to check if the frame is the ray or rd function.
    if frame.source:match("/ray.lua$") and frame.namewhat == "global" then
      return index
    end
  end

  return nil
end

return DefaultOriginFactory
