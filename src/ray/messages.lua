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

function messages.RayLog(values)
  return {
    label = messages.RayMessageType.Log,
    values = values,
  }
end

function messages.RayHtml(content)
  return {
    label = messages.RayMessageType.HTML,
    content = content,
  }
end

-- function RayLog.new(values)
--     return {
--         label = RayMessageType.Log,
--         values = values,
--     }
-- end
--
-- function RayText.new(content)
--     return {
--         label = RayMessageType.Text,
--         content = content,
--     }
-- end
--
-- function RayColor.new(color)
--     return {
--         color = color,
--     }
-- end
--
-- function RayHtml.new(content)
--     return {
--         label = RayMessageType.HTML,
--         content = content,
--     }
-- end
--
-- function RayClearAll.new()
--     return {
--         label = RayMessageType.ClearAll,
--     }
-- end
--
-- function RayConfetti.new()
--     return {
--         label = RayMessageType.Confetti,
--     }
-- end
--
-- function RayCharles.new(content)
--     return {
--         content = content,
--     }
-- end
--
-- function RayNewScreen.new(name)
--     return {
--         label = RayMessageType.NewScreen,
--         name = name,
--     }
-- end

return messages

