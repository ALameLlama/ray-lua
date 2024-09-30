# Usage

```lua
-- This imports 2 global functions ray() and rd()
require("ray")

function main()
    ray("Hello World!")

    ray("Hello World!").color("green")

    rd("Hello World!")
end
```

## Config

Create a file called `ray.lua` in the root of your project.

File:

```lua
return {
	enable = true,
	host = "localhost",
	port = 23517,
	remote_path = nil,
	local_path = nil,
	always_send_raw_values = false,
}
```

_Note:_ These are the default settings, You only need to add the settings you're changing.

## API Reference

- `ray(...message)`: Logs a message to the ray debugger.
- `ray(...message).color(color_name)`: Logs a message to the ray debugger with a specified color.
  - Green
  - Orange
  - Red
  - Purple
  - Blue
  - Gray
- `ray().screen_color(colour_name)`
  - Green
  - Orange
  - Red
  - Purple
  - Blue
  - Gray
- `ray().label(label)`
- `ray().size(size)`
- `ray().remove()`
- `ray().hide()`
- `ray().measure(name_or_closure)`
- `ray().measure_closure(closure)`
- `ray().notify(text)`
- `ray().to_json(...text)`
- `ray().die()`: Sends a exit signal after logging to ray debugger.
- `ray().clear()`: Clear the current Logs within ray debugger.
- `ray().ban()`: 🕶
- `ray().charles()`: 🎶 🎹 🎷 🕺
- `ray().raw(...args)`
- `ray().send(...args)`
- `ray().send_request(payload, meta)`

## Ray Client Settings

- `ray().project(project_name)`
- `ray().enable()`
- `ray().disable()`
- `ray().enabled()`
- `ray().disabled()`
- `ray().use_client(client)`
- `ray().new_screen(name)`
- `ray().clear_all()`
- `ray().clear_screen()`

## TODO:

- ray.trace
- ray.backtrace
- ray.caller
- ray.expand
- ray.expand_all
- ray.stop_time
- ray.json
- ray.file
- ray.image
- ray.class_name
- ray.luainfo
- ray.\_if
- ray.carbon
- ray.table
- ray.count
- ray.clear_counters
- ray.pause
- ray.separator
- ray.url
- ray.link
- `ray().html(html_content)`: Logs HTML content to the ray debugger.
- `ray().confetti()`: Fires off confetti 🎉
- ray.exception
- ray.xml
- ray.text
- ray.limit
- ray.once
- ray.catch
- ray.throw_exception
- ray.invade
- ray.pass
- ray.show_app
- ray.hide_app
- ray.send_custom
