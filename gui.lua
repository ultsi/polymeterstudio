
gui = {}
local aliveElements = {}
local registeredElements = {}

local elementObj = table.NewPropertyTable()
local elementMeta = {__index = elementObj}
function elementMeta:__tostring()
	return ("Element[%d] %s"):format(self:GetZPos(), self:GetType())
end

elementObj:AddProperty("Color", Color(255, 255, 255, 255))
elementObj:AddProperty("FGColor", Color(255, 255, 255, 255))
elementObj:AddProperty("BGColor", Color(128, 128, 128, 255))
elementObj:AddProperty("Name", "")
elementObj:AddProperty("Padding", 0)
elementObj:AddProperty("Type", "Element")
elementObj:AddProperty("XPos", 0)
elementObj:AddProperty("YPos", 0)
elementObj:AddProperty("ZPos", 1)
elementObj:AddProperty("Width", 10)
elementObj:AddProperty("Height", 10)
elementObj:AddProperty("Children", false)
elementObj:AddProperty("MouseInside", false)
elementObj:AddProperty("Visible", true)
elementObj:AddProperty("Parent", false)
elementObj:AddProperty("ClippingEnabled", false)
function elementObj:SetPosition(x, y) self:SetXPos(x) self:SetYPos(y) end
function elementObj:SetSize(w, h) self:SetWidth(w) self:SetHeight(h) end
function elementObj:Center()
	
	local w, h = self:GetSize()
	local mW, mH = love.graphics.getWidth(), love.graphics.getHeight()
	self:SetPosition(mW*0.5 - w*0.5, mH*0.5 - h*0.5)
	
end
function elementObj:AddChild(child) table.insert(self:GetChildren(), child) end
function elementObj:RemoveChild(child) table.RemoveValue(self:GetChildren(), child) end
function elementObj:Hide() self:SetVisible(false) end
function elementObj:Show() self:SetVisible(true) end

function elementObj:GetPosition()

	local x, y = self:GetXPos(), self:GetYPos()
	if(self:GetParent()) then
		local px, py = self:GetParent():GetPosition()
		return x + px, y + py
	end
	return x, y
end
	

function elementObj:MoveZPos(z)
	
	table.Move(aliveElements, self:GetZPos(), z)
	self:SetZPos(z)
	if(self:GetParent()) then
		self:GetParent():MoveZPos(z-1)
	end

end

function elementObj:GetLocalPosition() return self:GetXPos(), self:GetYPos() end
function elementObj:GetSize() return self:GetWidth(), self:GetHeight() end
function elementObj:HasFocus() return self:GetZPos() == #aliveElements end

function elementObj:Remove()
	
	self:OnRemove()
	table.RemoveValue(aliveElements, self)
	for k, v in pairs(self:GetChildren()) do
		v:Remove() 
	end 
	
	if(self:GetParent()) then
		self:GetParent():RemoveChild(self)
	end
	
end

function elementObj:Update(dt) end
function elementObj:Draw() end
function elementObj:Load() end
function elementObj:OnMouseEnter(x, y, side) end
function elementObj:OnMouseExit(x, y, side) end
function elementObj:OnMousePress(x, y) end
function elementObj:OnMouseRelease(x, y) end
function elementObj:OnRemove() end
function elementObj:OnKeyPress() end
function elementObj:OnKeyRelease() end
function elementObj:Refresh() end

ELEMENT_LEFT = 1
ELEMENT_RIGHT = 2
ELEMENT_TOP = 3
ELEMENT_BOTTOM = 4

function gui.GetAliveElements() return aliveElements end

function gui.NewElement(elementName, parent)

	if(not registeredElements[elementName]) then
		Error("No registered element named ".. elementName)
		return
	end
	
	local element = table.New(registeredElements[elementName])
	element.base = registeredElements[elementName]
	setmetatable(element, elementMeta)
	element:SetType(elementName)
	element:SetChildren({}) -- have to create a new table so it won't keep referencing the parents' table
	
	if(parent) then
		element:SetParent(parent)
		parent:AddChild(element)
	end
	
	aliveElements[#aliveElements+1] = element
	element:SetZPos(#aliveElements)
	element:Load()
	return element

end

function gui.RegisterElement(elementName, elementTable, baseElement)
	
	if(baseElement) then
		if(not registeredElements[baseElement]) then
			Error("No registered element named ".. baseElement)
			return
		end
		
		table.Inherit(elementTable, registeredElements[baseElement])
		Msg("Registered element "..elementName.. " with base ".. baseElement)
	else
		Msg("Registered element "..elementName)
	end
	
	registeredElements[elementName] = elementTable
	
end

local mouseHolder = false
function gui.SetMouseHolder(element) 

	events.Emit("ChangeMouseHolder", element, gui.GetMouseHolder())
	mouseHolder = element
	
end
function gui.GetMouseHolder() 
	
	return mouseHolder 
	
end

events.Hook("MousePressed", "GUI", function(x, y, button)

	local holder = gui.GetMouseHolder()
	if(holder) then
		holder:MoveZPos(#aliveElements)
		holder:OnMousePress(x, y, button)
	end
	
end)

events.Hook("MouseReleased", "GUI", function(x, y, button)

	local holder = gui.GetMouseHolder()
	if(holder) then
		holder:OnMouseRelease(x, y, button)
	end
	
end)

events.Hook("KeyPressed", "GUI", function(key, unicode)
	
	local activeElement = aliveElements[#aliveElements]
	if(activeElement) then
		activeElement:OnKeyPress(key, unicode)
	end
	
end)

events.Hook("KeyReleased", "GUI", function(key, unicode)
	
	local activeElement = aliveElements[#aliveElements]
	if(activeElement) then
		activeElement:OnKeyRelease(key, unicode)
	end
	
end)

local function DrawElement(element)
	
	local x, y = element:GetPosition()
	local w,h = element:GetSize()
	draw.Translate(x, y)
	if(element:GetClippingEnabled()) then
		draw.SetScissor(x, y, w, h)
	end
	element:Draw()
	draw.SetScissor()
	draw.Translate(-x,-y)
	
	for zPos, child in pairs(element:GetChildren()) do
		DrawElement(child)
	end
	
end

events.Hook("Draw", "DrawGUIElements", function()

	for zPos, element in pairs(aliveElements) do
		if(not element:GetParent() and element:GetVisible()) then
			DrawElement(element)
		end
	end

end)

local function calculateNearestSide(x, y, farX, farY, compareX, compareY)
	
	local diff = {{ELEMENT_LEFT, math.abs(x-compareX)}, {ELEMENT_RIGHT, math.abs(farX-compareX)}, {ELEMENT_TOP, math.abs(y-compareY)}, {ELEMENT_BOTTOM, math.abs(farY-compareY)}}
	table.sort(diff, function(a,b) return a[2]<b[2] end)
	
	return diff[1][1]
	
end

local function MouseCalculations(element, mx, my)
	
	local ex, ey = element:GetPosition()
	local w, h = element:GetSize()
	local within = math.IsWithin(mx, ex, ex + w) and math.IsWithin(my, ey, ey + h)
	if(not within) then 
		if(gui.GetMouseHolder() == element) then gui.SetMouseHolder() end 
		return 
	end
	
	gui.SetMouseHolder(element)
	for zPos, child in pairs(element:GetChildren()) do
		MouseCalculations(child, mx, my)
	end

end

events.Hook("Update", "GUIUpdate", function(dt)

	local mx, my = mouse.GetPosition()
	local lastHolder = gui.GetMouseHolder()
	for zPos, element in ipairs(aliveElements) do
		if(zPos ~= element:GetZPos()) then
			element:SetZPos(zPos)
		end
		
		if(not element:GetParent() and element:GetVisible()) then
			MouseCalculations(element, mx, my)
		end
		
		element:Update(dt)
	end
	if(lastHolder ~= gui.GetMouseHolder()) then
		if(lastHolder) then
			lastHolder:OnMouseExit(mx, my)
		end
		if(gui.GetMouseHolder()) then
			gui.GetMouseHolder():OnMouseEnter(mx, my)
		end
	end

end)
