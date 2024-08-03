-- https://github.com/spatie/ray/blob/main/src/Origin/OriginFactory.php

---@class OriginFactory
local OriginFactory = {}
OriginFactory.__index = OriginFactory

---@return Origin
function OriginFactory:get_origin()
  error("Method get_origin must be implemented")
end

return OriginFactory
