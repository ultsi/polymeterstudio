
sequences = {}
sequences.created = {}

local seqObj = {}

function seqObj:PlayStep(step)
	
	--default
	sound.Play(self:GetNote(step))

end

function seqObj:PlayCurrent()
	
	-- default function
	self:PlayStep(self.curStep)
	
end

function seqObj:AddNote(note)
	
	table.insert(self.pattern, note)

end

function seqObj:GetName() return self.name end
function seqObj:GetNote(step) return self.pattern[step] end
function seqObj:GetCurrentStep() return self.curStep end
function seqObj:GetCurrentNote() return self.pattern[self.curStep] end
function seqObj:Length() return #self.pattern end
function seqObj:IsOn() return self.on end
function seqObj:IsMuted() return self.on end
function seqObj:Mute() self.on = false end
function seqObj:UnMute() self.on = true end
function seqObj:OnRemove() end
function seqObj:Remove() self:OnRemove() sequences.Remove(self.name) end
function seqObj:HookStep(step, identifier, func)
	
	self.hooks[step] = self.hooks[step] or {}
	self.hooks[step][identifier] = func
	
end

function seqObj:UnHookStep(step, identifier)

	if(not self.hooks[step]) then return end
	self.hooks[step][identifier] = nil
	
end
 
function sequences.New(uniqueName, pattern)
	
	local seq = {name = uniqueName, on = true, pattern = pattern, curStep = 1, hooks = {}}
	setmetatable(seq, {__index = seqObj})
	sequences.created[uniqueName] = seq
	
	return seq
	
end

function sequences.GetMethodTable() return seqObj end

function sequences.Mute(uniqueName)

	if(sequences.created[uniqueName]) then
		sequences.created[uniqueName]["on"] = false
	end
	
end

function sequences.UnMute(uniqueName)

	if(sequences.created[uniqueName]) then
		sequences.created[uniqueName]["on"] = true
	end
	
end

function sequences.Get(uniqueName)

	return sequences.created[uniqueName]
	
end

function sequences.Remove(uniqueName)
	
	sequences.created[uniqueName] = nil
	
end

events.Hook("Tick", "SequencePlayback", function(curBeat)

	for uniqueName, seq in pairs(sequences.created) do
		if(seq:IsOn()) then
			seq.curStep = curBeat%seq:Length()+1
			if(seq:GetCurrentNote() ~= 0) then
				seq:PlayCurrent()
			end
			if(seq.hooks[seq.curStep]) then
				for identifier, func in pairs(seq.hooks[seq.curStep]) do
					local success, err = pcall(func, identifier)
					if(not success) then Error(err) end
				end
			end
		end
	end

end)
 