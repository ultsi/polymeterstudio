

MESSAGE_ERROR = 1
MESSAGE_DEBUG = 2
MESSAGE_PRINT = 3

local messageStack = {}
function Debug(...)
	
	local old = love.filesystem.read("debug.txt")
	local msg = table.concat({...}, " ")
	local s = old.."Debug: "..msg.."\r\n"
	love.filesystem.write("debug.txt", s)
	table.insert(messageStack, {type = MESSAGE_DEBUG, time = pm.curTime, msg = table.concat({...}, "   ")})
	events.Emit("Message", MESSAGE_DEBUG, ...)
	print(s)
	
end

function Error(...)
	
	local old = love.filesystem.read("errors.txt")
	local msg = table.concat({...}, " ")
	local s = old.."Error: "..msg.."\r\n"
	love.filesystem.write("errors.txt", s)
	table.insert(messageStack, {type = MESSAGE_ERROR, time = pm.curTime, msg = msg})
	events.Emit("Message", MESSAGE_ERROR, ...)
	print(s)
	
end

function Msg(...)

	print(...)
	table.insert(messageStack,{type = MESSAGE_PRINT, time = pm.curTime, msg = table.concat({...}, "   ")})
	events.Emit("Message", MESSAGE_PRINT, ...)
	
end

function GetMessages()
	
	return messageStack
	
end

do
	love.filesystem.write("debug.txt", "")
	love.filesystem.write("errors.txt", "")
end