rockspec_format = "3.0"
package = "ray"
version = "2.0.0-1"
source = {
	url = "git+https://github.com/ALameLlama/ray-lua",
	tag = "v2.0.0",
}
description = {
	summary = "Lua support for Ray Debugger by Spatie",
	detailed = [[
      This package provides a Lua client for the Ray Debugger by Spatie.
   ]],
	homepage = "https://github.com/ALameLlama/ray-lua",
	license = "MIT",
	issues_url = "https://github.com/ALameLlama/ray-lua/issues",
	labels = {
		"ray-debugger",
		"ray-spatie",
	},
	maintainer = "Nicholas Ciechanowski <nicholasaciechanowski@gmail.com>",
}
dependencies = {
	"lua >= 5.1, < 5.5",
	"http >= 0.4",
	"lua-cjson >= 2.1",
	"luafilesystem >= 1.8",
	"md5 >= 1.1",
	"uuid >= 0.3",
}
build = {
	type = "builtin",
	modules = {
		["ray"] = "src/helpers.lua", -- this emulates php global helper functions
		["ray.ray"] = "src/ray.lua",
		["ray.client"] = "src/client.lua",
		["ray.origin"] = "src/origin/origin.lua",
		["ray.origin.default_origin_factory"] = "src/origin/default_origin_factory.lua",
		["ray.origin.origin_factory"] = "src/origin/origin_factory.lua",
		["ray.origin.hostname"] = "src/origin/hostname.lua",
		["ray.request"] = "src/request.lua",
		["ray.settings"] = "src/settings/settings.lua",
		["ray.settings.settings_factory"] = "src/settings/settings_factory.lua",
	},
	copy_directories = { "doc" },
}
test = {
	type = "command",
	script = "src/tests/ray.lua",
}
test_dependencies = { "luaunit >= 3.4" }
