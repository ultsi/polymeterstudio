
local E = {}

function E:OnOK() end
function E:OnCancel() end
function E:SetOKText(text) self.okButton:SetText(text) self.okButton:SizeToContents() end
function E:SetCancelText(text) self.cancelButton:SetText(text) self.cancelButton:SizeToContents() end

function E:Load()
	
	self.answerBox = gui.NewElement("TextBox")
		self.answerBox:SetSize(300, 20)
	self.okButton = gui.NewElement("Button")
		self.okButton:SetText("Ok")
		self.okButton:SetBGColor(Color(72, 72, 72, 255))
		self.okButton:SizeToContents()
	self.cancelButton = gui.NewElement("Button")
		self.cancelButton:SetText("Cancel")
		self.cancelButton:SetBGColor(Color(72, 72, 72, 255))
		self.cancelButton:SizeToContents()
		
	self.okButton.DoClick = function(okButton, mouseButton)
		self:OnOK(self.answerBox:GetText())
	end
	
	self.answerBox.OnEnter = function(answerBox)
		self:OnOK(self.answerBox:GetText())
	end
	
	self.cancelButton.DoClick = function(cancelButton, mouseButton)
		self:OnCancel()
	end
	
	local titleHeight = self:GetGrabAreaHeight()
	self.vList = gui.NewElement("VerticalList", self)
	self.vList:SetPadding(5)
	self.vList:SetItemGap(5)
	self.vList:SetItemAlign(ALIGN_RIGHT)
	self.vList:SetPosition(0, titleHeight)
	self.vList:AddItem(self.answerBox)
	
	self.buttonList = gui.NewElement("HorizontalList")
	self.buttonList:SetPadding(0)
	self.buttonList:SetItemGap(10)
	self.buttonList:AddItem(self.okButton)
	self.buttonList:AddItem(self.cancelButton)
	self.buttonList:SetHeight(30)
	self.vList:AddItem(self.buttonList)
	local w, h = self.vList:GetSize()
	self:SetSize(w, h + titleHeight)
	
end

gui.RegisterElement("Form", E, "Frame")
