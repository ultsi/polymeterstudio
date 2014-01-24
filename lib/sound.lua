
sound = {}
sound.loaded = {}

sound.noteNames = {"c", "cis", "d", "dis", "e", "f", "fis", "g", "gis", "a", "ais", "b"}
notes = {}

for octave = 0, 8 do
	for noteNo, noteName in pairs(sound.noteNames) do
		notes[noteName..octave] = noteName..octave
		notes[octave*12+noteNo] = noteName..octave
	end
end

-- 1 = prime, 2 = minor second, 3 = major second etc..
function sound.GetRelativePitch(interval)
	
	return ((2)^(1/12))^(interval-1)
	
end

function sound.PlaySource(source)

	local origvol = source:getVolume()
	local randfrac = (-1)^math.random(1,2) * math.random(1,99) * 10^-3
	source:setVolume(origvol + randfrac)
	source:resume()
	source:play()
	
	source:setVolume(origvol)

end
	
function sound.Play(source)

	if(type(source) == "table") then
		for k,v in pairs(source) do
			sound.PlaySource(v)
		end
	else sound.PlaySource(source) end

end

function sound.PlayFile(fileName, volume, pitch)
	
	if(not sound.loaded[fileName]) then
		sound.Precache(fileName)
	end
	
	volume = volume or 1
	pitch = pitch or 1
	
	local source = love.audio.newSource(sound.loaded[fileName])
	source:setVolume(volume)
	source:setPitch(pitch)
	source:resume()
	source:play()
	
	source:setVolume(1)
	source:setPitch(1)
	
end
	
function sound.Precache(fileName)
	
	if(sound.loaded[fileName]) then return sound.loaded[fileName] end
	Msg("Precaching "..fileName)
	sound.loaded[fileName] = love.sound.newSoundData(fileName)
	return sound.loaded[fileName]

end
