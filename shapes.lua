
shapes = {}
local shapeObj = {}

function shapeObj:Draw(x, y, r, sx, sy, ox, oy)
	
	love.graphics.draw(self.canvas, x, y, r, sx, sy, ox, oy)
	
end

function shapeObj:GetSize()
	
	return self.w, self.h
	
end

function shapes.New(width, height, drawFunc)
	
	local shape = {canvas = love.graphics.newCanvas(width, height), w = width, h = height}
	setmetatable(shape, {__index = shapeObj})
	
	love.graphics.setCanvas(shape.canvas)
	local success, err = pcall(drawFunc)
	love.graphics.setCanvas()
	
	if(not success) then Error(err) end
	
	return shape
	
end
