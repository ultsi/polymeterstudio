

local P = table.NewPropertyTable()
P:AddProperty("LastTickTime", 0)
P:AddProperty("TickSustain", 2)
P:AddProperty("Sequence", false)
P:AddProperty("Step", 0)
P:AddProperty("TickColor", Color(255, 0, 0, 255))
function P:Tick() self:SetLastTickTime(pm.curTime) end
function P:Draw()

	local timeElapsed = pm.curTime - self:GetLastTickTime()
	local size = math.Limit(1-timeElapsed/self:GetTickSustain(), 0.1, 1)
	local color = self:GetTickColor()
	color = BlendColors(self:GetColor(), color, 1-size)
	draw.Point(0, 0, self:GetWidth()*size, color)
	
end

function P:OnRemove()

	self:GetSequence():UnHookStep(self:GetStep(), self)
	
end

gui.RegisterElement("CirclePoint", P)
 
local E = table.NewPropertyTable()
E.radius = 100
E.circleColor = Color(255, 255, 255, 255)
E.activeColor = Color(255, 255, 255, 255)
E.staticColor = Color(255, 255, 255, 255)
E.lineColor = Color(255, 255, 255, 255)
E.travellerColor = Color(255, 255, 255, 255)
E.nameColor = Color(255, 255, 255, 255)
E.traveller = false
E.points = {}

E:AddProperty("Radius", 100)
E:AddProperty("CircleColor", Color(255, 255, 255, 255))
E:AddProperty("ActiveColor", Color(255, 255, 255, 255))
E:AddProperty("StaticColor", Color(255, 255, 255, 255))
E:AddProperty("LineColor", Color(255, 255, 255, 255))
E:AddProperty("TravellerColor", Color(255, 255, 255, 255))
E:AddProperty("NameColor", Color(255, 255, 255, 255))

function E:SetCenterPosition(x, y) self:SetPosition(x - self.radius, y - self.radius) end
function E:SetTravellerColor(c) 
	self.travellerColor = c
	self.traveller = shapes.New(32, 32, function()

		draw.Point(16, 4, 4, c)
		draw.Point(16, 8, 8, c)
		draw.Point(16, 12, 12, c)
		draw.Point(16, 16, 16, c)

	end)
end

function E:Draw()

	local radius = self.radius
	local x, y = radius, radius
	local seq = self.sequence
	local len = seq:Length()
	if(len < 1) then return end
	local circleDef = len*4-1
	local circlePoints = {}
	for i = 0, circleDef do
		local rad = i/circleDef * 2 * math.pi - 1/2*math.pi
		local cx, cy = x + math.cos(rad) * radius, y + math.sin(rad) * radius 
		
		circlePoints[#circlePoints+1] = cx
		circlePoints[#circlePoints+1] = cy
	end
	draw.Polygon("line", 2, self:GetCircleColor(), circlePoints)
	local frac = pm.beatLastTime / pm.beatLen
	draw.SimpleText(seq.name, "Arial", x, y, self:GetNameColor(), ALIGN_CENTER)
	
	local rad = (seq:GetCurrentStep()-1)/len * 2 * math.pi - 1/2*math.pi + frac * 2/len * math.pi
	local sin, cos = math.sin(rad), math.cos(rad)
	local cx, cy = x + cos * radius, y + sin * radius 
	draw.SimpleLine(x, y, cx, cy, 3, self:GetLineColor())
	
	if(self.traveller) then
		local sin, cos = math.sin(rad-math.pi*0.05), math.cos(rad-math.pi*0.05)
		local cx, cy = x + cos * radius, y + sin * radius 
		local w, h = self.traveller:GetSize()
		w, h = w * 0.5, h * 0.5
		self.traveller:Draw(cx - cos*w, cy - sin*h, rad)
	end

end

function E:OnSequenceSet(seq)

	local radius = self.radius
	local x, y = self.radius, self.radius
	local seq = self.sequence
	local len = seq:Length()
	
	for step, note in pairs(seq.pattern) do
		local rad = (step-1)/(len) * 2 * math.pi - 1/2*math.pi
		local cx, cy = x + math.cos(rad) * radius, y + math.sin(rad) * radius 
		if(note ~= 0) then
			local point = gui.NewElement("CirclePoint", self)
				point:SetColor(self.staticColor)
				point:SetPosition(cx, cy)
				point:SetSize(15, 10)
				point:SetClippingEnabled(false)
				point:SetSequence(seq)
				point:SetStep(step)
				point:SetColor(self:GetStaticColor())
				point:SetTickColor(self:GetActiveColor())
				seq:HookStep(step, point, point.Tick)
			
			self.points[step] = point
		end
	end
	
end

function E:UpdateValues()
	
	local radius = self.radius
	local x, y = self.radius, self.radius
	local seq = self.sequence
	local len = seq:Length()
	
	for k,v in pairs(self.points) do v:Remove() end
	self.points = {}
	for step, note in pairs(seq.pattern) do
		local rad = (step-1)/(len) * 2 * math.pi - 1/2*math.pi
		local cx, cy = x + math.cos(rad) * radius, y + math.sin(rad) * radius 
		if(note ~= 0) then
			local point = self.points[step] or gui.NewElement("CirclePoint", self)
				point:SetPosition(cx, cy)
				point:SetSize(15, 10)
				point:SetClippingEnabled(false)
				point:SetSequence(seq)
				point:SetStep(step)
				point:SetColor(self:GetStaticColor())
				point:SetTickColor(self:GetActiveColor())
				seq:HookStep(step, point, point.Tick)
			
			self.points[step] = point
		end
	end
	
end

gui.RegisterElement("CircleVisual", E, "Visual")
