
local LABEL = table.NewPropertyTable()
LABEL:SetProperty("Color", Color(255, 255, 255, 255))
LABEL:AddProperty("Text", "")
LABEL:AddProperty("Font", "Arial")

function LABEL:Draw() 

	local w, h = self:GetWidth(), self:GetHeight()
	draw.SimpleText(self:GetText(), self:GetFont(), w*0.5, h*0.5, self:GetColor(), ALIGN_CENTER, ALIGN_CENTER)
	
end

function LABEL:SizeToContents()

	local textW, textH = draw.GetTextSize(self:GetText(), self:GetFont())
	local padding = self:GetPadding()
	self:SetSize(textW + padding, textH + padding)
	
end

gui.RegisterElement("Label", LABEL)