-- https://github.com/spatie/ray/blob/1.41.2/src/Concerns/RayScreenColors.php

local RayScreenColors = {
	screen_green = function(self)
		return self.screen_color("green")
	end,

	screen_orange = function(self)
		return self.screen_color("orange")
	end,

	screen_red = function(self)
		return self.screen_color("red")
	end,

	screen_purple = function(self)
		return self.screen_color("purple")
	end,

	screen_blue = function(self)
		return self.screen_color("blue")
	end,

	screen_gray = function(self)
		return self.screen_color("gray")
	end,

	screen_grey = function(self)
		return self.screen_color("gray")
	end,
}

return RayScreenColors
