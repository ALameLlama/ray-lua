local inspect = require("inspect")

---@class ArgumentConverter
local ArgumentConverter = {}
ArgumentConverter.__index = ArgumentConverter

---@param arg any
---@return table { value: any, is_html: boolean }
function ArgumentConverter.convert_to_primitive(arg)
	if arg == nil then
		return { value = nil, is_html = false }
	end

	local arg_type = type(arg)
	if arg_type == "string" or arg_type == "number" or arg_type == "boolean" then
		return { value = arg, is_html = false }
	end

	-- TODO: create a html dumper for inspect similar to symfony html dumper
	return { value = inspect(arg), is_html = false }
end

return ArgumentConverter
