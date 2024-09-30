local M = {}

function M.make_path_os_safe(path)
	return path:gsub("/", package.config:sub(1, 1))
end

return M
