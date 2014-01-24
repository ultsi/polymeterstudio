
local function TestVisuals()

	local pno = piano.New("M1_Z8")
	local seq = sequences.New("Modul 47", {notes.c6, notes.gis5, notes.fis5, notes.f5, 0, notes.c6, notes.gis5, notes.fis5, notes.f5, 0})
	pno:SetSequence(seq)
	
	local palette = NewPaletteFromHex("#030B13", "#35618F", "#83BAFD", "#E4EEFD", "#5A92D2")
	
	local vis = gui.NewElement("CircleVisual")
		vis:SetRadius(100)
		vis:SetCenterPosition(300, 300)
	vis:SetSequence(seq)
	
	vis:SetCircleColor(palette[1])
	vis:SetActiveColor(palette[2])
	vis:SetStaticColor(palette[3])
	vis:SetLineColor(palette[4])
	vis:SetTravellerColor(palette[5])
	-- vis:EnableGrabbing(false)
	
	local pno = piano.New("M1_Z8")
	local seq = sequences.New("Modul 47_2", {notes.f3, notes.c4, notes.f4, notes.gis4, notes.ais4, notes.c5, notes.ais4, notes.gis4, notes.f4, notes.dis4, notes.ais3, notes.c4, notes.gis3, notes.fis3})
	pno:SetSequence(seq)
	
	local palette = NewPaletteFromHex("#748E3F", "#BB8A66", "#B7BCBB", "#CACCCD", "#9BAE86")
	local vis = gui.NewElement("CircleVisual")
		vis:SetRadius(60)
		vis:SetCenterPosition(300, 300)
		vis:SetSequence(seq)
	
	vis:SetCircleColor(palette[1])
	vis:SetActiveColor(palette[2])
	vis:SetStaticColor(palette[3])
	vis:SetLineColor(palette[4])
	vis:SetTravellerColor(palette[5])
	-- vis:EnableGrabbing(false)
	
end

local function TestFrames()
	
	local frame = gui.NewElement("Frame")
		frame:SetPosition(200, 300)
		frame:SetSize(100, 200)
		frame:SetTitle("Frame 1")
		frame:SetName("Frame 1")
		frame:SetColor(Color(0, 255, 0, 255))
		
	local label = gui.NewElement("Label", frame)
		label:SetText("Label 1")
		label:SetPosition(5, 10)
		label:SizeToContents()
	
	local frame = gui.NewElement("Frame")
		frame:SetPosition(400, 300)
		frame:SetSize(200, 100)
		frame:SetTitle("Frame 2")
		frame:SetName("Frame 2")
		frame:SetColor(Color(0, 0, 255, 255))
		
	local label = gui.NewElement("Label", frame)
		label:SetText("Label 2")
		label:SetPosition(5, 10)
		label:SizeToContents()
		
	local textBox = gui.NewElement("TextBox", frame)
		textBox:SetPosition(50, 50)
		textBox:SetSize(100, 20)
		
end

local function TestQuestionBox()
	
	local qBox = gui.NewElement("QuestionBox")
		qBox:SetPosition(200, 300)
		qBox:SetTitle("QBOX 1")
		function qBox:OnAnswer(answer)
			print(answer)
		end
		function qBox:OnCancel()
			print("Canceled 1")
		end
		
		
	local qBox = gui.NewElement("QuestionBox")
		qBox:SetPosition(200, 300)
		qBox:SetTitle("QBOX2")
		function qBox:OnAnswer(answer)
			print(answer)
		end
		function qBox:OnCancel()
			print("Canceled 2")
		end
	
end

local function TestChoiceBox()
		
		local cBox = gui.NewElement("ChoiceBox")
			cBox:SetPosition(100, 100)
			cBox:AddChoice("This")
			cBox:AddChoice("should")
			cBox:AddChoice("work?")
			cBox:SizeToContents()
			
end

local function TestButton()
	
	local panel = gui.NewElement("Label")
		panel:SetText("")
		panel:SetSize(200, 300)
		panel:SetPosition(200, 300)
	
	local btn = gui.NewElement("Button", panel)
		btn:SetText("Test")
		btn:SetPosition(5, 5)
		function btn:DoClick() print("lol") end
		btn:SizeToContents()
		
end

events.Hook("Load", "TESTGUI", function()
	
	-- TestButton()
	-- TestFrames()
	-- TestVisuals()
	-- TestTextBox()
	TestQuestionBox()
	-- TestChoiceBox()
	
end)
