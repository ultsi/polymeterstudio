
local E = {}
E.title = "Console"
E.curLine = 0
local messageColors = {}
messageColors[MESSAGE_ERROR] = Color(255, 0, 0, 255)
messageColors[MESSAGE_DEBUG] = Color(255, 200, 0, 255)
messageColors[MESSAGE_PRINT] = Color(255, 255, 255, 255)
local messages = {}

Setup("Console messagelimit", 5)

function E:Draw()
	
	local messages = GetMessages()
	local messageCount = #messages
	local limit = math.Limit(Setting("Console messagelimit"), 1, messageCount)
	local line = math.Limit(self.curLine, 0, messageCount-limit)
	local low, high = messageCount - limit - line + 1, messageCount - line
	for k = low, high do
		local msgInfo = messages[k]
		local color = messageColors[msgInfo.type]
		draw.SimpleText(msgInfo.msg, "Console", 0, (k-low)*14, color)
	end
	
end

gui.RegisterElement("Console", E, "Frame")
