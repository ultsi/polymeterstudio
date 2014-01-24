
samples = {}
samples.ringing = {}

local defaultSample = {source = false, audioData = false}
local sampleObj = table.NewPropertyTable()

sampleObj:AddProperty("VolumeVariation", 10)
sampleObj:AddProperty("Volume", 1)
sampleObj:AddProperty("Pitch", 1)
sampleObj:AddProperty("Sustain", 1)
sampleObj:AddProperty("FadeOutTime", 0)
sampleObj:AddProperty("Playing", false)
sampleObj:AddProperty("RingTime", 0)

function sampleObj:Play()
	
	samples.ringing[self] = true
	self:SetPlaying(true)
	self:SetRingTime(0)
	local variation = (-math.random(1, self:GetVolumeVariation())^2*10^-3)
	self.source:setVolume(self:GetVolume() + variation)
	self.source:setPitch(self:GetPitch())
	self.source:rewind()
	self.source:play()
	
end

function sampleObj:Stop()
	
	self:SetRingTime(0)
	self:SetPlaying(false)
	self.source:stop()
	self.source:setVolume(self:GetVolume())
	samples.ringing[self] = nil
	
end

function sampleObj:FadeOut(frac)
	
	self.source:setVolume(self:GetVolume() * frac)
	
end

function sampleObj:SetPosition(x, y, z) self.source:setPosition(x, y, z) end

function samples.NewFromFile(fileName)
	
	return samples.NewFromAudioData(sound.Precache(fileName))
	
end

function samples.NewFromAudioData(audioData)
	
	local sample = table.New(defaultSample)
	sample.audioData = audioData
	sample.source = love.audio.newSource(audioData)
	
	setmetatable(sample, {__index = sampleObj})
	return sample
	
end

events.Hook("Update", "SampleWatch", function(dt)
	
	for sample, _ in pairs(samples.ringing) do
		
		local ringTime, sustain = sample:GetRingTime(), sample:GetSustain()
		if(ringTime > sustain) then
			sample:Stop()
		end
		local ringTimeLeft, fadeOutTime = sustain - ringTime, sample:GetFadeOutTime()
		if(ringTimeLeft < fadeOutTime) then
			sample:FadeOut(ringTimeLeft / fadeOutTime)
		end
		sample:SetRingTime(ringTime + dt)
		
	end
	
end)

