# Usage

```lua
local ray = require("ray")

function main()
    ray("Hello World");

    ray("Hello World!"):color("green");

    ray():html("<strong>Hello World!</strong>");
end
```

## Config

Either create a file called `ray.lua` in the root of your project or via the config module.

File:

```lua
return {
  protocol = "http",
  hostname = "localhost",
  port = "23517",
}
```

Config Module:

```lua
local conf = require("ray.config")
local ray = require('ray')

function main()
    conf.config.port = 8888
    ray("Request is sent to localhost:8888")
end
```

## API Reference

Here's a list of the main functions provided by ray in lua:

- `ray(message)`: Logs a message to the ray debugger.
- `ray(message):color(color_name)`: Logs a message to the ray debugger with a specified color.
  - Green
  - Orange
  - Red
  - Purple
  - Blue
  - Gray
- `ray():html(html_content)`: Logs HTML content to the ray debugger.
- `ray():die()`: Sends a exit signal after logging to ray debugger.
