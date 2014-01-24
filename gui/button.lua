
local BUTTON = table.NewPropertyTable()
BUTTON:SetProperty("FGColor", Color(200, 200, 200, 255))
BUTTON:SetProperty("Color", Color(200, 200, 200, 255))
BUTTON:SetProperty("Padding", 5)
BUTTON:AddProperty("HoverColor", Color(255, 255, 255, 255))
BUTTON:AddProperty("ClickColor", Color(255, 128, 0, 255))
BUTTON:AddProperty("TextAlign", ALIGN_CENTER)

function BUTTON:DoClick(button) end
function BUTTON:OnMouseRelease(x, y, button) self:DoClick(button) self:SetColor(self:GetFGColor()) end
function BUTTON:OnMousePress(x, y, button) self:SetColor(self:GetClickColor()) end
function BUTTON:OnMouseEnter(x, y) self:SetColor(self:GetHoverColor()) end
function BUTTON:OnMouseExit(x,y) self:SetColor(self:GetFGColor()) end
function BUTTON:Draw() 

	local w, h = self:GetSize()
	local align = self:GetTextAlign()
	draw.Box(0, 0, w, h, self:GetBGColor())
	draw.BoxOutlines(0, 0, w, h, Color(0, 0, 0, 255))
	draw.SimpleText(self:GetText(), self:GetFont(), w*0.5, h*0.5, self:GetColor(), align, align)
	
end
gui.RegisterElement("Button", BUTTON, "Label")