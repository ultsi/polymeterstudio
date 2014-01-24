
local E = {}
E.title = "Frame"
E.grabArea = {lowX = 0, lowY = 0, highX = 5000, highY = 20}
E.doGrabbing = true
E.grabAreaColor = Color(72, 72, 72, 255)
E.showCloseButton = true
table.AddProperty(E, "GrabAreaColor", Color(72, 72, 72, 255))

function E:Draw()
	
	local w, h = self:GetSize()
	local lineColor = self:GetFGColor()
	local rectColor = self:GetBGColor()
	local grabArea = self.grabArea
	draw.Box(0, 0, w, h, rectColor)
	draw.Box(grabArea.lowX, grabArea.lowY, math.Limit(grabArea.highX, 1, w), math.Limit(grabArea.highY, 1, h), self:GetGrabAreaColor())
	
	draw.SimpleText(self.title, "Arial", w*0.5, 0, lineColor, ALIGN_CENTER)
	
end


function E:SetTitle(title)
	
	self.title = title
	
end

function E:EnableCloseButton(bool)
	
	self.showCloseButton = bool
	
end

function E:SetGrabArea(x1, y1, x2, y2)
	
	self.grabArea = {lowX = x1, lowY = y1, highX = x2, highY = y2}
	
end

function E:GetGrabArea()
	
	return self.grabArea
	
end

function E:GetGrabAreaHeight()
	
	return self.grabArea.highY - self.grabArea.lowY
	
end

function E:GetGrabAreaWidth()
	
	return self.grabArea.highX - self.grabArea.lowX
	
end

function E:EnableGrabbing(bool)
	
	self.doGrabbing = bool
	
end

function E:OnMousePress(x, y, button)

	local grabArea = self.grabArea
	local ex, ey = self:GetPosition()
	if(not self:GetParent() and self.doGrabbing and button == MOUSE_LEFT and math.IsWithin(x-ex, grabArea.lowX, grabArea.highX) and math.IsWithin(y-ey, grabArea.lowY, grabArea.highY)) then
		self.mouseGrabPosition = {x-ex, y-ey}
	end

end

function E:OnMouseRelease(x, y, button)

	if(button == MOUSE_LEFT or not button) then
		self.mouseGrabPosition = nil
	end

end

function E:Update(dt)

	if(self.mouseGrabPosition) then
		local gx, gy = self.mouseGrabPosition[1], self.mouseGrabPosition[2]
		local mx, my = mouse.GetPosition()
		self:SetPosition(mx-gx, my-gy)
	end

end

gui.RegisterElement("Frame", E)
