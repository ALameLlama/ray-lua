rockspec_format = "3.0"
package = "ray"
version = "1.0.0-1"
source = {
   url = "git+https://github.com/ALameLlama/ray-lua",
   tag = "v1.0.0",
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
   "uuid >= 0.3",
}
build = {
   type = "builtin",
   modules = {
      ["ray"] = "src/ray/ray.lua",
      ["ray.util"] = "src/ray/util.lua",
      ["ray.messages"] = "src/ray/messages.lua",
   },
   copy_directories = { "doc" },
}
test_dependencies = { "luaunit >= 3.4" }
