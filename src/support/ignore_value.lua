-- https://github.com/spatie/ray/blob/main/src/Support/IgnoredValue.php

---@class SupportIgnoredValue
IgnoredValue = {}
IgnoredValue.__index = IgnoredValue

function IgnoredValue.make()
  return setmetatable({}, IgnoredValue)
end

return IgnoredValue
