local messages = {}

messages.RayMessageType = {
	Log = "Log",
	Text = "Text",
	HTML = "HTML",
	ClearAll = "ClearAll",
	Confetti = "Confetti",
	NewScreen = "NewScreen",
}

messages.RayContentType = {
	Log = "log",
	Custom = "custom",
	Color = "color",
	ClearAll = "clear_all",
	Confetti = "confetti",
	NewScreen = "new_screen",
}

messages.defaultColor = "Gray"
messages.RayColors = {
	Green = "green",
	Orange = "orange",
	Red = "red",
	Purple = "purple",
	Blue = "blue",
	Gray = "gray",
	Grey = "gray",
}

-- https://github.com/spatie/ray/blob/main/src/Payloads/LogPayload.php
--- @param values table
function messages.RayLog(values)
	return {
		label = messages.RayMessageType.Log,
		values = values,
	}
end

-- https://github.com/spatie/ray/blob/main/src/Payloads/TextPayload.php
--- @param content string
function messages.RayText(content)
	return {
		label = messages.RayMessageType.Text,
		content = content,
	}
end

-- https://github.com/spatie/ray/blob/main/src/Payloads/HtmlPayload.php
--- @param content string
function messages.RayHtml(content)
	return {
		label = messages.RayMessageType.HTML,
		content = content,
	}
end

-- https://github.com/spatie/ray/blob/main/src/Payloads/ColorPayload.php
--- @param color string
function messages.RayColor(color)
	if color == nil then
		color = messages.defaultColor
	else
		color = color:sub(1, 1):upper() .. color:sub(2):lower()
	end

	local colorEnum = messages.RayColors[color] or messages.RayColors.Gray

	return {
		color = colorEnum,
	}
end

-- https://github.com/spatie/ray/blob/main/src/Payloads/ClearAllPayload.php
function messages.RayClearAll()
	return {
		label = messages.RayMessageType.ClearAll,
	}
end

-- https://github.com/spatie/ray/blob/main/src/Payloads/ConfettiPayload.php
function messages.RayConfetti()
	return {
		label = messages.RayMessageType.Confetti,
	}
end

-- https://github.com/spatie/ray/blob/main/src/Ray.php#L498
function messages.RayCharles()
	return {
		content = "🎶 🎹 🎷 🕺",
	}
end

-- https://github.com/spatie/ray/blob/main/src/Payloads/NewScreenPayload.php
--- @param name string
function messages.RayNewScreen(name)
	return {
		label = messages.RayMessageType.NewScreen,
		name = name,
	}
end

return messages
