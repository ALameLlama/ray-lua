-- https://github.com/spatie/ray/blob/1.41.2/src/Support/IgnoredValue.php

---@class SupportIgnoredValue
IgnoredValue = {}
IgnoredValue.__index = IgnoredValue

function IgnoredValue.make()
	return setmetatable({}, IgnoredValue)
end

return IgnoredValue
