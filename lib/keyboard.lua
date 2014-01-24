
local keyBinds = {}

keyboard = {}

keyboard.IsDown = love.keyboard.isDown

function keyboard.IsShiftDown()

	return keyboard.IsDown("lshift") or keyboard.IsDown("rshift")
	
end

function keyboard.IsCtrlAltDown()

	return keyboard.IsDown("lctrl") and keyboard.IsDown("lalt") or keyboard.IsDown("ralt")
	
end

function keyboard.Bind(key, onPressFunc, onReleaseFunc)
	
	keyBinds[key] = {pressed = onPressFunc, released = onReleaseFunc}

end

function keyboard.UnBind(key)
	
	keyBinds[key] = nil
	
end

events.Hook("KeyPressed", "KeyBindPressed", function(key, unicode)
	
	if(keyBinds[key]) then
		local bind = keyBinds[key]
		if(bind.pressed) then
			local success, err = pcall(bind.pressed)
			if(not success) then
				Error(err)
			end
		end
	end
	
end)

events.Hook("KeyReleased", "KeyBindReleased", function(key, unicode)
	
	if(keyBinds[key]) then
		local bind = keyBinds[key]
		if(bind.released) then
			local success, err = pcall(bind.released)
			if(not success) then
				Error(err)
			end
		end
	end
	
end)

function love.keypressed(key, unicode)
	
	events.Emit("KeyPressed", key, unicode)
	
end

function love.keyreleased(key, unicode)

	events.Emit("KeyReleased", key, unicode)
	
end