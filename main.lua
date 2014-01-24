
love.filesystem.load("helperfuncs.lua")()
LoadLua("settings.lua")
Setup("Tempo", 70)
Setup("Precision", 16)
pm = {}
pm.curBeat = 0
pm.curTime = 0
pm.beatLen = 0
pm.lastBeatTime = 0

__INITIALISED = false

LoadLua("eventsystem.lua")
LoadLua("messages.lua")
LoadLuaInFolder("lib/")
LoadLua("samples.lua")
LoadLua("sequences.lua")
LoadLua("instruments.lua")
LoadLuaInFolder("instruments/")
LoadLua("shapes.lua")
LoadLua("gui.lua")
LoadLua("gui/label.lua")
LoadLua("gui/button.lua")
LoadLua("gui/textbox.lua")
LoadLua("gui/lists.lua")
LoadLua("gui/frame.lua")
LoadLua("gui/questionbox.lua")
LoadLua("gui/form.lua")
LoadLua("console.lua")
LoadLua("visuals.lua")
LoadLuaInFolder("visuals/")
LoadLua("record.lua")

function love.update(dt)
	
	local tempo, precision = Setting("Tempo"), Setting("Precision")
	pm.curTime = pm.curTime + dt
	pm.beatLastTime = pm.curTime - pm.lastBeatTime
	pm.beatLen = 60 / tempo * (4 / precision)
	if(pm.beatLastTime >= pm.beatLen) then
		pm.curBeat = pm.curBeat + 1
		pm.lastBeatTime = pm.curTime
		pm.beatLastTime = 0
		events.Emit("Tick", pm.curBeat)
	end
	
	events.Emit("Update", dt)
	
end

function love.load()

	draw.CreateFont("Arial", "arial.ttf", 16)
	events.Emit("Load")
	
end

function love.draw()

	events.Emit("Draw")
	draw.SimpleText("Tempo: "..Setting("Tempo"), "Arial", 10, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
	
end

keyboard.Bind("f9", function() Setup("Tempo", Setting("Tempo") + 1) end)
keyboard.Bind("f10", function() Setup("Tempo", Setting("Tempo") - 1) end)
