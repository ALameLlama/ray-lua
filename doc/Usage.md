# Usage

```lua
-- This imports 2 functions ray() and rd()
ray, rd = unpack(require("ray"))

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

- `ray(...message)`: Logs messages to the Ray debugger.
- `ray(message, another_one)`: Can take multiple messages to the Ray debugger.
- `ray(...message).color(color_name)`: Logs a message with a specified color:
  - green
  - orange
  - red
  - purple
  - blue
  - gray
- `ray().green()`: Alias for `ray().color("green")`
- `ray().orange()`: Alias for `ray().color("orange")`
- `ray().red()`: Alias for `ray().color("red")`
- `ray().purple()`: Alias for `ray().color("purple")`
- `ray().blue()`: Alias for `ray().color("blue")`
- `ray().gray()`: Alias for `ray().color("gray")`
- `ray().screen_color(color_name)`: Changes the entire screen’s background color:
  - green
  - orange
  - red
  - purple
  - blue
  - gray
- `ray().screen_green()`: Alias for `ray().screen_color("green")`
- `ray().screen_orange()`: Alias for `ray().screen_color("orange")`
- `ray().screen_red()`: Alias for `ray().screen_color("red")`
- `ray().screen_purple()`: Alias for `ray().screen_color("purple")`
- `ray().screen_blue()`: Alias for `ray().screen_color("blue")`
- `ray().screen_gray()`: Alias for `ray().screen_color("gray")`
- `ray().label(label)`: Attaches a label to the message.

- `ray().size(size)`: Sets the size of the message (large or small).
  - sm
  - lg
- `ray().small()`: Alias for `ray().size("sm")`
- `ray().large()`: Alias for `ray().size("lg")`
- `ray().remove()`: Removes a specific message from the Ray debugger.
- `ray().hide()`: Hides the message from view.
- `ray().measure(name_or_closure)`: Measures execution time for a named task or closure.
- `ray().measure_closure(closure)`: Times the execution of a given closure.
- `ray().notify(text)`: Sends a notification.
- `ray().to_json(...text)`: Converts and logs data as JSON.
- `ray().die()`: Logs the message and halts execution.
- `ray().clear()`: Clears the current logs in the Ray debugger.
- `ray().ban()`: Silences the output (ban Ray logging).
- `ray().charles()`: Logs a playful note (specific to your implementation).
- `ray().raw(...args)`: Logs raw, unformatted data.
- `ray().send(...args)`: Sends the message to the Ray debugger.
- `ray().send_request(payload, meta)`: Sends a custom request with payload and metadata.
- `ray().html(html)`: Sends a string of HTML to the Ray debugger

## Ray Client Settings

- `ray().project(project_name)`: Specifies the current project name.
- `ray().enable()`: Enables Ray logging.
- `ray().disable()`: Disables Ray logging.
- `ray().enabled()`: Checks if Ray logging is enabled.
- `ray().disabled()`: Checks if Ray logging is disabled.
- `ray().use_client(client)`: Switches to a different client.
- `ray().new_screen(name)`: Starts a new screen with an optional name.
- `ray().clear_all()`: Clears all logs from Ray.
- `ray().clear_screen()`: Clears the current screen.

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
