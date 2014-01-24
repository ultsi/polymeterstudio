
local CBOX = {}

function CBOX:Load()
	
	self.choicesList = gui.NewElement("VerticalList")
	self.choicesList:SetItemGap(5)
	self.choicesList:Hide()
	
end

function CBOX:AddChoice(choice)
	
	if(self:GetText() == "") then self:SetText(choice) end
	local choiceLabel = gui.NewElement("Label")
		choiceLabel:SetText(choice)
		choiceLabel:SizeToContents()
		choiceLabel.OnMouseRelease = function(choiceLabel)
			
			self:SetText(choiceLabel:GetText())
			self.choicesList:Hide()
			
		end
		
	self.choicesList:AddItem(choiceLabel)
	
end

function CBOX:OnMouseRelease(x, y, button)
	
	if(not self.choicesList:IsVisible()) then
		self.choicesList:Show()
		self.choicesList:SetPosition(self:GetPosition())
	end
	
end

gui.RegisterElement("ChoiceBox", CBOX, "Label")