local messages = {}

messages.message_type = {
	log = "Log",
	text = "Text",
	html = "HTML",
	clear_all = "ClearAll",
	confetti = "Confetti",
	new_screen = "NewScreen",
}

messages.content_type = {
	log = "log",
	custom = "custom",
	color = "color",
	clear_all = "clear_all",
	confetti = "confetti",
	new_screen = "new_screen",
}

messages.colors = {
	green = "green",
	orange = "orange",
	red = "red",
	purple = "purple",
	blue = "blue",
	gray = "gray",
	grey = "gray",
}

messages.default_color = messages.colors.gray

-- https://github.com/spatie/ray/blob/main/src/Payloads/LogPayload.php
--- @param values table
function messages.log(values)
	return {
		label = messages.message_type.log,
		values = values,
	}
end

-- https://github.com/spatie/ray/blob/main/src/Payloads/TextPayload.php
--- @param content string
function messages.text(content)
	return {
		label = messages.message_type.text,
		content = content,
	}
end

-- https://github.com/spatie/ray/blob/main/src/Payloads/HtmlPayload.php
--- @param content string
function messages.html(content)
	return {
		label = messages.message_type.html,
		content = content,
	}
end

-- https://github.com/spatie/ray/blob/main/src/Payloads/ColorPayload.php
--- @param color string
function messages.color(color)
	if color == nil then
		color = messages.default_color
	else
		color = color:lower()
	end

	local color_enum = messages.colors[color] or messages.colors.gray

	return {
		color = color_enum,
	}
end

-- https://github.com/spatie/ray/blob/main/src/Payloads/ClearAllPayload.php
function messages.clear_all()
	return {
		label = messages.message_type.clear_all,
	}
end

-- https://github.com/spatie/ray/blob/main/src/Payloads/ConfettiPayload.php
function messages.confetti()
	return {
		label = messages.message_type.confetti,
	}
end

-- https://github.com/spatie/ray/blob/main/src/Ray.php#L498
function messages.charles()
	return {
		content = "🎶 🎹 🎷 🕺",
	}
end

-- https://github.com/spatie/ray/blob/main/src/Payloads/NewScreenPayload.php
--- @param name string
function messages.new_screen(name)
	return {
		label = messages.message_type.new_screen,
		name = name,
	}
end

return messages
