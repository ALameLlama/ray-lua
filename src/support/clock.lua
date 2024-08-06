-- https://github.com/spatie/ray/blob/main/src/Support/CacheStore.php

---@class SupportClock
local Clock = {}
Clock.__index = Clock

---@return integer
function Clock:now()
	return os.time()
end

return Clock
