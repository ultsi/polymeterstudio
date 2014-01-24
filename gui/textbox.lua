
local TEXTBOX = table.NewPropertyTable()

TEXTBOX:AddProperty("OutlineColor", Color(0, 0, 0, 255))
TEXTBOX:SetProperty("BGColor", Color(255, 255, 255, 255))
TEXTBOX:SetProperty("Color", Color(0, 0, 0, 255))
function TEXTBOX:OnEnter() end

function TEXTBOX:Draw()

	local w, h = self:GetSize()
	draw.Box(0, 0, w, h, self:GetBGColor())
	draw.SimpleText(self:GetText(), self:GetFont(), 2, 0, self:GetColor())
	draw.BoxOutlines(0, 0, w, h, self:GetOutlineColor())
	
end

local normal = {["/"] = "-", ["`"] = "§", ["-"] = "+", ["="] = "´", [";"] = "ö", ["'"] = "ä", ["\\"] = "'"}
local shift = {	["1"] = "!", ["2"] = "\"", ["3"] = "#", ["4"] = "$", ["5"] = "%", ["6"] = "&", ["7"] = "/", ["8"] = "(", ["9"] = ")", 
						["0"] = "=", [","] = ";", ["."] = ":", ["-"] = "_", ["+"] = "?", ["´"] = "`", ["¨"] = "^", ["'"] = "*" }
local altctrl = {	["1"] = "", ["2"] = "@", ["3"] = "£", ["4"] = "$", ["5"] = "€", ["6"] = "", ["7"] = "{", ["8"] = "[", ["9"] = "]", 
						["0"] = "}", [","] = "", ["."] = "", ["-"] = "", ["+"] = "\"", ["´"] = "", ["¨"] = "~", ["'"] = "" }

function TEXTBOX:OnKeyPress(key, unicode)
	
	local curText = self:GetText()
	if(key:len() == 1) then
		-- it's a printable character
		key = normal[key] or key -- switch to finnish keyboard layout
		if(keyboard.IsDown("capslock")) then
			key = key:upper()
		end
		if(keyboard.IsShiftDown()) then	
			key = key:ChangeCase()
			key = shift[key] or key
		end
		if(keyboard.IsCtrlAltDown()) then
			key = altctrl[key] or key
		end
		self:SetText(curText..key)
	
	elseif(key == "backspace") then
		
		self:SetText(curText:sub(1,-2))
		
	elseif(key == "return") then
		
		self:OnEnter()
		
	end

end

gui.RegisterElement("TextBox", TEXTBOX, "Label")