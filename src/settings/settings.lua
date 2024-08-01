-- https://github.com/spatie/ray/blob/main/src/Settings/Settings.php

Settings = {}
Settings.__index = Settings

---@param settings table
function Settings:new(settings)
  local obj = {}
  setmetatable(obj, Settings)

  -- Use rawset to avoid infinite recursion in __newindex
  rawset(obj, "settings", settings or {})
  rawset(obj, "loaded_using_settings_file", false)
  rawset(obj, "default_settings", {
    enable = true,
    host = "localhost",
    port = 23517,
    remote_path = nil,
    local_path = nil,
    always_send_raw_values = false,
  })

  for k, v in pairs(obj.default_settings) do
    if obj.settings[k] == nil then
      obj.settings[k] = v
    end
  end

  return obj
end

function Settings:mark_as_loaded_using_settings_file()
  self.loaded_using_settings_file = true

  return self
end

---@param defaults table
function Settings:set_default_settings(defaults)
  for name, value in pairs(defaults) do
    if self:was_loaded_using_config_file(name) then
      self.settings[name] = value
    end
  end

  return self
end

---@param name string
function Settings:was_loaded_using_config_file(name)
  if self.settings[name] == nil then
    return true
  end

  if not self.loaded_using_settings_file then
    return true
  end

  return false
end

-- This is trying to implement the PHP __get magic method
---@param name string
---@param value any
function Settings:__newindex(name, value)
  self.settings[name] = value
end

-- This is trying to implement the PHP __set magic method
---@param name string
function Settings:__index(name)
  -- We need this so functions can be accessed
  if type(Settings[name]) == "function" then
    return Settings[name]
  else
    return rawget(self.settings, name)
  end
end

return Settings
