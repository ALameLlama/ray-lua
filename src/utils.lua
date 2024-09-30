---@type Payload
local Payload = require("ray.payload")

---@class Utils
local M = {}

-- PHP array_map method
---@param func function
---@param array table
---@return table
function M.array_map(func, array)
	local result = {}

	for i, v in ipairs(array) do
		result[i] = func(v)
	end

	return result
end

-- PHP array_filter method
---@param func function
---@param array table
---@return table
function M.array_filter(func, array)
	local result = {}

	for _, v in ipairs(array) do
		if func(v) then
			table.insert(result, v)
		end
	end

	return result
end

-- PHP array_values method
---@param array table
---@return table
function M.array_values(array)
	local result = {}

	for _, v in pairs(array) do
		table.insert(result, v)
	end

	return result
end

-- PHP array_keys method
---@param array table
---@return table
function M.array_keys(array)
	local result = {}

	for k, _ in pairs(array) do
		table.insert(result, k)
	end

	return result
end

-- PHP array_merge method
---@param array1 table
---@param array2 table
---@return table
function M.array_merge(array1, array2)
	local result = {}

	if type(array1) ~= "table" or type(array2) ~= "table" then
		return result
	end

	-- Handle array-like elements
	for _, v in ipairs(array1) do
		table.insert(result, v)
	end

	for _, v in ipairs(array2) do
		table.insert(result, v)
	end

	-- Handle dictionary-like elements
	for k, v in pairs(array1) do
		if type(k) ~= "number" then
			result[k] = v
		end
	end

	for k, v in pairs(array2) do
		if type(k) ~= "number" then
			result[k] = v
		end
	end

	return result
end

-- PHP array_key_exists method
---@param key any
---@param array table
function M.array_key_exists(key, array)
	return array[key] ~= nil
end

---@param payloads Payload|Payload[]
---@return boolean
function M.payloads_is_empty(payloads)
	if not payloads then
		return true
	end

	if type(payloads) ~= "table" then
		return true
	end

	local payloads_mt = getmetatable(getmetatable(payloads))

	-- it's not a Payload object, then it's an array of payloads
	if not M.payload_is_object(payloads) then
		return M.payloads_is_empty(payloads[1])
	end

	if payloads_mt.__index ~= Payload.__index then
		return true
	end

	return false
end

---@param payload Payload|Payload[]
---@return boolean
function M.payload_is_object(payload)
	if not payload then
		return false
	end

	local payload_mt = getmetatable(getmetatable(payload))

	if not payload_mt then
		return false
	end

	return payload_mt.__index == Payload.__index
end

function M.join_paths(base, name)
	local sep = package.config:sub(1, 1)

	if base:sub(-1) == sep then
		return base .. name
	else
		return base .. sep .. name
	end
end

return M
