-- https://github.com/spatie/ray/blob/1.41.2/src/Support/Clock.php

---@class SupportClock
local Clock = {}
Clock.__index = Clock

---@return integer
function Clock:now()
	return os.time()
end

return Clock
