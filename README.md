# ray-lua

This is currently WIP and still missing features but has basic ray debugging.

## Examples

```lua
local ray = require("ray")

function main()
    ray("Hello World");

    ray("Hello World!"):color("green");

    ray():html("<strong>Hello World!</strong>");
end
```
