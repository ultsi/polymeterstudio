
local settings = {}

function Setting(key)
	
	return settings[key]
	
end

function Setup(key, value)
	
	settings[key] = value
	
end

function GetConfiguration()

	return settings
	
end

