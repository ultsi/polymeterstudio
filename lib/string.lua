
local str = getmetatable("").__index

function str:ChangeCase()
	
	return self:lower() == self and self:upper() or self:lower()
	
end
