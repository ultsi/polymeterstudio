
console = false
events.Hook("Load", "ConsoleInit", function()
	
	console = gui.NewElement("Form")
		console:SetVisible(false)
		console:SetTitle("Input to run Lua")
		console:SetOKText("Run")
		console:SetCancelText("Hide")
		function console:OnOK(text)
			
			local success, err = loadstring(text)
			if(success) then
				success, err = pcall(success)
				if(err) then
					Error(err)
				end
			else
				Error(err)
			end
		
		end
		
		function console:OnCancel()
			self:SetVisible(false)
		end
	
end)

keyboard.Bind("f8", function() if(console) then console:SetVisible(not console:GetVisible()) end end)
