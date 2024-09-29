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
		["ray.payload.clear_all_payload"] = "src/payloads/clear_all_payload.lua",
		["ray.payload.color_payload"] = "src/payloads/color_payload.lua",
		["ray.payload.custom_payload"] = "src/payloads/custom_payload.lua",
		["ray.payload.hide_payload"] = "src/payloads/hide_payload.lua",
		["ray.payload.json_string_payload"] = "src/payloads/json_string_payload.lua",
		["ray.payload.label_payload"] = "src/payloads/label_payload.lua",
		["ray.payload.log_payload"] = "src/payloads/log_payload.lua",
		["ray.payload.new_screen_payload"] = "src/payloads/new_screen_payload.lua",
		["ray.payload.measure_payload"] = "src/payloads/measure_payload.lua",
		["ray.payload.notify_payload"] = "src/payloads/notify_payload.lua",
		["ray.payload.null_payload"] = "src/payloads/null_payload.lua",
		["ray.payload.payload_factory"] = "src/payloads/payload_factory.lua",
		["ray.payload.remove_payload"] = "src/payloads/remove_payload.lua",
		["ray.payload.screen_color_payload"] = "src/payloads/screen_color_payload.lua",
		["ray.payload.size_payload"] = "src/payloads/size_payload.lua",
		["ray.request"] = "src/request.lua",
		["ray.settings"] = "src/settings/settings.lua",
		["ray.settings.settings_factory"] = "src/settings/settings_factory.lua",
		["ray.support.cache_store"] = "src/support/cache_store.lua",
		["ray.support.clock"] = "src/support/clock.lua",
		["ray.support.counters"] = "src/support/counters.lua",
		["ray.support.ignored_value"] = "src/support/ignored_value.lua",
		["ray.support.limiters"] = "src/support/limiters.lua",
		["ray.support.rate_limiter"] = "src/support/rate_limiter.lua",
		["ray.support.stopwatch"] = "src/support/stopwatch/stopwatch.lua",
		["ray.support.stopwatch.event"] = "src/support/stopwatch/event.lua",
		["ray.support.stopwatch.period"] = "src/support/stopwatch/period.lua",
		["ray.support.stopwatch.section"] = "src/support/stopwatch/section.lua",
		["ray.utils"] = "src/utils.lua",
	},
	copy_directories = { "doc" },
}
test = {
	type = "command",
	script = "tests/tests.lua",
}
test_dependencies = { "luaunit >= 3.4" }
