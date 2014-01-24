
events = {}
events.hooks = {}

function events.Hook(eventName, uniqueName, callFunc)
	
	events.hooks[eventName] = events.hooks[eventName] or {}
	events.hooks[eventName][uniqueName] = callFunc
	
end

function events.UnHook(eventName, uniqueName)
	
	if(events.hooks[eventName]) then
		events.hooks[eventName][uniqueName] = nil
	end
	
end

function events.Emit(eventName, ...)
	
	if(not events.hooks[eventName]) then return end
	for uniqueName, callFunc in pairs(events.hooks[eventName]) do
		local success, err = pcall(callFunc, ...)
		if(not success) then
			Error(err)
		end
	end
	
end