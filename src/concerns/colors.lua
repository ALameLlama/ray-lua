-- https://github.com/spatie/ray/blob/1.41.2/src/Concerns/RayColors.php

local RayColors = {
	green = function(self)
		return self.color("green")
	end,

	orange = function(self)
		return self.color("orange")
	end,

	red = function(self)
		return self.color("red")
	end,

	purple = function(self)
		return self.color("purple")
	end,

	blue = function(self)
		return self.color("blue")
	end,

	gray = function(self)
		return self.color("gray")
	end,

	grey = function(self)
		return self.color("gray")
	end,
}

return RayColors
