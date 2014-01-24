
instruments = {}

local instrObj = {}
local defaultInstrument = {	volume = 1.0,
											sustain = 1.0,
											samples = {},
											position = {0, 0, 0},
											pitch = 1.0,
											direction = {0, 0, 0},
											sequence = false
											}

function instrObj:PlayNote(noteName)
	
	if(type(noteName) == "table") then
		for k, v in pairs(noteName) do self:PlayNote(v) end
	else
		local sample = self.samples[noteName]
		sample:Play()
	end
	
end

function instrObj:SetSequence(seq)
	
	if(self.sequence) then self:RemoveSequence() end
	seq.PlayStep = function(seq, step)
		self:PlayNote(seq:GetCurrentNote())
	end
	
	self.sequence = seq
		
end

function instrObj:RemoveSequence()
	
	local seq = self.sequence
	seq.PlayBeat = sequences.GetMethodTable().PlayBeat
	
	self.sequence = false
	
end

function instrObj:SetVolumeVariation(variation)
	
	self.volumeVariation = variation
	for k, sample in pairs(self.samples) do
		sample:SetVolumeVariation(variation)
	end
	
end
	

function instrObj:SetVolume(volume) 
	
	self.volume = volume 
	for k, sample in pairs(self.samples) do
		sample:SetVolume(volume)
	end
	
end

function instrObj:SetSustain(sustain)

	self.sustain = sustain
	for k, sample in pairs(self.samples) do
		sample:SetSustain(sustain)
	end

end

function instrObj:SetFadeOutTime(fade)
	
	self.fadeOutTime = fade
	for k, sample in pairs(self.samples) do
		sample:SetFadeOutTime(fade)
	end
	
end

function instrObj:SetPosition(x, y, z) 
	
	self.position.x, self.position.y, self.position.z = x, y, z 
	for k, sample in pairs(self.samples) do
		sample:SetPosition(x, y, z)
	end
	
end

function instrObj:SetDirection(x, y, z) 
	
	self.direction.x, self.direction.y, self.direction.z = x, y, z 
	for k, sample in pairs(self.samples) do
		sample:SetDirection(x, y, z)
	end
	
end

function instrObj:SetPitch(pitch) 
	
	self.pitch = pitch 
	for k, sample in pairs(self.samples) do
		sample:SetPitch(pitch)
	end
	
end

function instrObj:GetVolume() return self.volume end
function instrObj:GetSustain() return self.sustain end
function instrObj:GetSample(noteName) return self.samples[noteName] end
function instrObj:GetPosition() return unpack(self.position) end
function instrObj:GetDirection() return unpack(self.direction) end
function instrObj:GetPitch() return self.pitch end
function instrObj:Remove() for k,v in pairs(self.samples) do self.samples[k] = nil end end
 
function instruments.New(instrumentName, samplePath, precacheFunc)
	
	local instr = table.New(defaultInstrument)
	instr.name = instrumentName
	instr.samplePath = samplePath
	
	setmetatable(instr, {__index = instrObj})
	
	local path = "samples/"..samplePath
	local files = love.filesystem.enumerate(path)
	for i, fileName in pairs(files) do
		fileName = fileName:lower()
		precacheFunc(instr, fileName, path)
	end
	
	return instr
	
end
