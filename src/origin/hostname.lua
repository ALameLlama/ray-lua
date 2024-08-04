-- https://github.com/spatie/ray/blob/main/src/Origin/Hostname.php

---@class OriginHostname
---@field protected hostname string?
local Hostname = {}
Hostname.__index = Hostname
Hostname.hostname = nil

---@return string?
function Hostname:get()
	-- Use os.execute or another method to get the hostname
	if self.hostname == nil then
		local handle = io.popen("hostname")

		if handle == nil then
			return nil
		end

		self.hostname = handle:read("*a")

		handle:close()
	end

	return self.hostname
end

---@param hostname string
function Hostname:set(hostname)
	self.hostname = hostname
end

return Hostname
