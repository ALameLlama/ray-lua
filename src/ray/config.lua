local M = {}

local config_file = loadfile("ray.lua")

M.config = {
  protocol = "http",
  hostname = "localhost",
  port = "23517",
}

if config_file then
  M.config = config_file()
end

return M
