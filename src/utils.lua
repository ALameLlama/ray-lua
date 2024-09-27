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

return M
