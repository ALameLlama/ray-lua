---@class TestUtils
local M = {}

function M.make_path_os_safe(path)
	return path:gsub("/", package.config:sub(1, 1))
end

function M.getSnapshot(name)
	local file_path = M.make_path_os_safe("./tests/snapshots/" .. name .. ".lua")
	local chunk, err = loadfile(file_path)

	if not chunk then
		error("Failed to load file: " .. err)
	end

	return chunk()
end

return M
