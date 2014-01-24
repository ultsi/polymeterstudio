
love.filesystem.setIdentity("music")
Debug = print
Error = print

function LoadLua(fileName)
	
	Debug("Loading "..fileName)
	local success, err = love.filesystem.load(fileName)
	if(not success) then
		Error("Couldn't load "..fileName..": "..err)
		return
	end
		
	success, err = pcall(love.filesystem.load(fileName))
	if(not success) then
		Error("Couldn't load "..fileName..": "..err)
	end
	
end

function LoadFiles(files)
	
	for i, fileName in pairs(files) do
		LoadLua(fileName)
	end
	
end

function LoadLuaInFolder(folder)
	
	for i, fileName in pairs(love.filesystem.enumerate(folder)) do
		if(fileName:sub(-4) == ".lua") then
			LoadLua(folder..fileName)
		end
	end
	
end

local profiles = {}
function StartProfile(n)
	profiles[n] = os.clock()
end

function StopProfile(n)
	Msg("Profile "..n.." took "..os.clock()-profiles[n].." seconds.")
	profiles[n] = nil
end
