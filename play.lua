
local pno, drumset

events.Hook("Load", "LoadPiano", function()

	pno = piano.New("M1_Z8")
	drumset = drums.New("01")

end)

keyboard.Bind("a", function() pno:PlayNote(notes.c4) end)
keyboard.Bind("s", function() pno:PlayNote(notes.d4) end)
keyboard.Bind("d", function() pno:PlayNote(notes.e4) end)
keyboard.Bind("f", function() pno:PlayNote(notes.f4) end)
keyboard.Bind("g", function() pno:PlayNote(notes.g4) end)
keyboard.Bind("h", function() pno:PlayNote(notes.a4) end)
keyboard.Bind("j", function() pno:PlayNote(notes.b4) end)

keyboard.Bind("q", function() drumset:PlayNote("kick") end)
keyboard.Bind("w", function() drumset:PlayNote("hat_closed") end)
keyboard.Bind("e", function() drumset:PlayNote("snare") end)
keyboard.Bind("r", function() drumset:PlayNote("ride") end)
