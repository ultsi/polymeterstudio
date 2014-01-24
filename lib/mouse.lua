
mouse = {}
MOUSE_LEFT = "l"
MOUSE_RIGHT = "r"
MOUSE_MIDDLE = "m"
MOUSE_WHEELUP = "wu"
MOUSE_WHEELDOWN = "wd"
MOUSE_BUTTON4 = "x1"
MOUSE_BUTTON5 = "x2"

mouse.GetPosition = love.mouse.getPosition
mouse.GetX = love.mouse.getX
mouse.GetY = love.mouse.getY
mouse.SetPosition = love.mouse.setPosition
mouse.IsDown = love.mouse.isDown

function mouse.Grab() love.mouse.setGrab(true) end
function mouse.Release() love.mouse.setGrab(false) end

local pressHooks, releaseHooks = {}, {}

-- function mouse.HookButtons(press, release)

	-- pressHooks[press] = true
	-- releaseHooks[release] = true
	
-- end

-- function mouse.UnHookButtons(press, release)
	
	-- pressHooks[press] = nil
	-- releaseHooks[release] = nil
	
-- end

function love.mousepressed(x, y, button)

	events.Emit("MousePressed", x, y, button)
	for func, bool in pairs(pressHooks) do
		local success, err = pcall(func, x, y, button)
		if(not success) then Error(err) end
	end

end

function love.mousereleased(x, y, button)

	events.Emit("MouseReleased", x, y, button)
	for func, bool in pairs(releaseHooks) do
		local success, err = pcall(func, x, y, button)
		if(not success) then Error(err) end
	end

end
