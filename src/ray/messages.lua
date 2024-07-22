local messages = {}

messages.RayMessageType = {
	Log = "Log",
	Text = "Text",
	HTML = "HTML",
	ClearAll = "ClearAll",
	Confetti = "Confetti",
	Charles = "Charles",
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

messages.RayColors = {
	Green = "green",
	Orange = "orange",
	Red = "red",
	Purple = "purple",
	Blue = "blue",
	Gray = "gray",
}

--- @param values table
function messages.RayLog(values)
	return {
		label = messages.RayMessageType.Log,
		values = values,
	}
end

--- @param content string
function messages.RayText(content)
	return {
		label = messages.RayMessageType.Text,
		content = content,
	}
end

--- @param content string
function messages.RayHtml(content)
	return {
		label = messages.RayMessageType.HTML,
		content = content,
	}
end

--- @param color string
function messages.RayColors(color)
	return {
		color = color,
	}
end

function messages.RayClearAll()
	return {
		label = messages.RayMessageType.ClearAll,
	}
end

function messages.RayConfetti()
	return {
		label = messages.RayMessageType.Confetti,
	}
end

--- @param content string
function messages.RayCharles(content)
	return {
		label = messages.RayMessageType.Charles,
		content = content,
	}
end

--- @param name string
function messages.RayNewScreen(name)
	return {
		label = messages.RayMessageType.NewScreen,
		name = name,
	}
end

return messages
