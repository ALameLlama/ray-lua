-- https://github.com/spatie/ray/blob/1.41.2/src/Concerns/RaySizes.php

local RaySizes = {
	small = function(self)
		return self.size("sm")
	end,

	large = function(self)
		return self.size("lg")
	end,
}

return RaySizes
