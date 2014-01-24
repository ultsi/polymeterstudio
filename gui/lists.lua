local VLIST = table.NewPropertyTable()
VLIST.items = {}
VLIST:AddProperty("ItemGap", 5)
VLIST:AddProperty("ItemAlign", ALIGN_CENTER)

function VLIST:AddItem(item)
	
	item:SetParent(self)
	self:AddChild(item)
	
	local newCount = #self.items+1
	self.items[newCount] = item
	self:Refresh()
	return newCount
	
end

function VLIST:RemoveItem(index)
	
	local item = table.remove(self.items, index)
	item:SetParent(nil)
	self:RemoveChild(item)
	self:Refresh()
	return item

end

function VLIST:Refresh()
	
	local pad = self:GetPadding()
	local gap = self:GetItemGap()
	local x, y = pad, pad
	local maxW = 0
	for k, item in pairs(self:GetChildren()) do
		local w, h = item:GetSize()
		item:SetPosition(x, y)
		y = y + h + gap
		if(w > maxW) then maxW = w end
	end
	
	self:SetSize(maxW + pad*2, y - gap)
	
end

function VLIST:Draw() end

gui.RegisterElement("VerticalList", VLIST)

local HLIST = {}

function HLIST:Refresh()
	
	local pad = self:GetPadding()
	local gap = self:GetItemGap()
	local x, y = pad, pad
	local maxH = 0
	for k, item in pairs(self:GetChildren()) do
		item:SetPosition(x, y)
		local w, h = item:GetSize()
		x = x + w + gap
		if(h > maxH) then maxH = h end
	end
	
	self:SetSize(x - gap, maxH + pad*2)
	
end

gui.RegisterElement("HorizontalList", HLIST, "VerticalList")
