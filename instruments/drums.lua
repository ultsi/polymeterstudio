
drums = {}

local validNames = {hat_closed = true, hat_pedal = true, hat_open = true, snare = true, crash = true, ride = true, kick = true}

local function precache(drumset, fileName, path)
	
	local noExt = fileName:sub(1, fileName:find("%.")-1)
	if(validNames[noExt]) then
		local audioData = sound.Precache(path..fileName)
		local sample = samples.NewFromAudioData(audioData)
		drumset.samples[noExt] = sample
	end
	
end

function drums.New(sampleFolder)

	local drumset = instruments.New("Drumset 01", "drums/"..sampleFolder.."/", precache)
	
	return drumset
	
end
	
