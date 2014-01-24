
local map = {a = notes.c4, s = notes.d4, d = notes.e4, f = notes.f4, g = notes.g4, h = notes.a4, j = notes.b4, k = notes.c5}
local recordState = false
local beatNotes = false
local curRecord

events.Hook("Tick", "Recording", function(curBeat)
	
	if(beatNotes and recordState) then
		curRecord:AddNote(#beatNotes > 0 and beatNotes or 0)
		curRecord.vis:UpdateValues()
		curRecord.pno:PlayNote(beatNotes)
		beatNotes = {}
	end

end)

events.Hook("KeyPressed", "Recording", function(key, unicode)

	if(recordState and map[key]) then
		beatNotes = beatNotes or {}
		beatNotes[#beatNotes+1] = map[key]
	end

end)

events.Hook("Load", "Metronome", function()
	
	local metronome = sequences.New("Metronome", {"kick", 0, 0, 0})
	local drumset = drums.New("01")
		drumset:SetSequence(metronome)
	
end)

local i = 0
local function NewRecord(name)

	StartProfile("NewRecord")
	i = i + 1
	StartProfile("Sequence")
	curRecord = sequences.New(i, {})
	curRecord:Mute()
	StopProfile("Sequence")
	
	StartProfile("Instrument")
	local pno = piano.New("M1_Z8")
		pno:SetFadeOutTime(0.5)
		pno:SetSequence(curRecord)
	StopProfile("Instrument")
		
	StartProfile("Visual")
	local vis = gui.NewElement("CircleVisual")
		vis:SetRadius(100)
		vis:SetCenterPosition(300, 300)
		vis:SetSequence(curRecord)
		
	local palette = NewPaletteFromHex("#030B13", "#35618F", "#83BAFD", "#E4EEFD", "#5A92D2")
	
	vis:SetCircleColor(palette[1])
	vis:SetActiveColor(palette[2])
	vis:SetStaticColor(palette[3])
	vis:SetLineColor(palette[4])
	vis:SetTravellerColor(palette[5])
	vis:SetClippingEnabled(false)
	StopProfile("Visual")
	
	curRecord.vis = vis
	curRecord.pno = pno
	function curRecord:OnRemove()
		self.pno:Remove()
	end
	StopProfile("NewRecord")

end

local function FinishRecord()
	
	curRecord.vis:SetSequence(curRecord)
	curRecord.vis:UpdateValues()
	curRecord:UnMute()
	curRecord = false

end

keyboard.Bind("f5", function()
	
	recordState = not recordState
	if(recordState) then
		beatNotes = false
		-- local qBox = gui.NewElement("QuestionBox")
			-- qBox:Center()
			-- qBox:SetQuestion("Name this track.")
			-- function qBox:OnAnswer(answer)
				-- if(answer == "") then return false end
				-- recordState = true
				-- NewRecord(answer)
				-- return true
			-- end
			-- function qBox:OnCancel()
				-- recordState = false
			-- end
		NewRecord()
 	else
		FinishRecord()
		beatNotes = false
	end
		
end)