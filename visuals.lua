
visuals = {}
local E = {} -- visual element
E.sequence = false

function E:OnSequenceSet(seq) end
function E:UpdateValues() end

function E:SetSequence(seq)
	
	self.sequence = seq
	self:SetVisible(true)
	self:OnSequenceSet(seq)

end

function E:Load()
	
	local kill = gui.NewElement("Button", self)
	kill:SetText("Kill")
	kill:SetPosition(90, 0)
	kill:SizeToContents()
	
	function kill.DoClick(kill, button)
		kill:Remove()
		self.sequence:Remove()
		self:Remove()
	end
	
	self:SetGrabArea(0, 0, 5000, 50)
	self:SetVisible(false)
	
end

function E:Draw()
	
		
	
end

gui.RegisterElement("Visual", E, "Frame")

