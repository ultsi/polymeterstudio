
draw = {}
draw.fonts = {}

local graf = love.graphics
draw.SetScissor = graf.setScissor
draw.Translate = graf.translate

function draw.CreateFont(fontName, fileName, fontSize)

	draw.fonts[fontName] = love.graphics.newFont(fileName, fontSize)
	
end

function draw.GetTextSize(text, font)
	
	local font = draw.fonts[font]
	local w = font:getWidth(text)
	local h = font:getHeight()
	
	return w, h
	
end
	

function draw.SimpleLine(x1, y1, x2, y2, width, color)

	graf.setColor(color.r, color.g, color.b, color.a)
	graf.setLineWidth(width)
	graf.line(x1, y1, x2, y2)
	
end

function draw.Box(x, y, w, h, color)
	
	graf.setColor(color.r, color.g, color.b, color.a)
	graf.rectangle("fill", x, y, w, h)
	
end

function draw.BoxOutlines(x, y, w, h, color)

	graf.setColor(color.r, color.g, color.b, color.a)
	graf.rectangle("line", x, y, w, h)
	
end

ALIGN_CENTER = 0
ALIGN_LEFT = 1
ALIGN_RIGHT = 2
ALIGN_TOP = 1
ALIGN_BOTTOM = 2

function draw.SimpleText(text, font, x, y, color, xAlign, yAlign)
	
	xAlign = xAlign or ALIGN_LEFT
	yAlign = yAlign or ALIGN_TOP
	local font = draw.fonts[font]
	local w,h = font:getWidth(text), font:getHeight()
	if(xAlign == ALIGN_CENTER) then
		x = x - w*0.5
	elseif(xAlign == ALIGN_RIGHT) then
		x = x - w
	end
	if(yAlign == ALIGN_CENTER) then
		y = y - h*0.5
	elseif(yAlign == ALIGN_BOTTOM) then
		y = y + h
	end
	graf.setColor(color.r, color.g, color.b, color.a)
	graf.setFont(font)
	graf.printf(text, x, y, 100000, "left")
	
end

function draw.WrappableText(text, font, x, y, xLimit, color)
	
	graf.setColor(color.r, color.g, color.b, color.a)
	graf.setFont(draw.fonts[font])
	graf.printf(text, x, y, xLimit, "left")
	
end

function draw.Polygon(drawMode, width, color, points)

	graf.setColor(color.r, color.g, color.b, color.a)
	graf.setLineWidth(width)
	graf.polygon(drawMode, points)
	
end

function draw.Point(x, y, size, color)

	graf.setColor(color.r, color.g, color.b, color.a)
	graf.setPointSize(size)
	graf.point(x,y)

end
