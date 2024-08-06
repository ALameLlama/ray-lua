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
		["ray.origin.hostname"] = "src/origin/hostname.lua",
		["ray.origin.origin_factory"] = "src/origin/origin_factory.lua",
		["ray.payload"] = "src/payloads/payload.lua",
		["ray.payload.bool_payload"] = "src/payloads/bool_payload.lua",
		["ray.payload.log_payload"] = "src/payloads/log_payload.lua",
		["ray.payload.null_payload"] = "src/payloads/null_payload.lua",
		["ray.payload.payload_factory"] = "src/payloads/payload_factory.lua",
		["ray.request"] = "src/request.lua",
		["ray.settings"] = "src/settings/settings.lua",
		["ray.settings.settings_factory"] = "src/settings/settings_factory.lua",
		["ray.support.counters"] = "src/support/counters.lua",
		["ray.support.limiters"] = "src/support/limiters.lua",
		["ray.support.rate_limiter"] = "src/support/rate_limiter.lua",
		["ray.support.cache_store"] = "src/support/cache_store.lua",
		["ray.support.clock"] = "src/support/clock.lua",
	},
	copy_directories = { "doc" },
}
test = {
	type = "command",
	script = "tests/tests.lua",
}
test_dependencies = { "luaunit >= 3.4" }
