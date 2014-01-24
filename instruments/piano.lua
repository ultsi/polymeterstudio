
piano = {}

local function precache(instr, fileName, path)
	
	if(fileName:match("c(%d)")) then
		local audioData = sound.Precache(path..fileName)
		for i, noteName in pairs(sound.noteNames) do
			local octave = fileName:match("(%d)")
			local sample = samples.NewFromAudioData(audioData)
			sample:SetPitch(sound.GetRelativePitch(i))
			instr.samples[noteName..octave] = sample
		end
	end
	
end

function piano.New(sampleFolder)
	
	local pno = instruments.New("Korg", "piano/"..sampleFolder.."/", precache)
	
	return pno
	
end

