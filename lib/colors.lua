
function Color(r, g, b, a)
	
	return {r = r, g = g, b = b, a = a}
	
end

function BlendColors(c1, c2, p1)
	
	local p2 = 1 - p1
	return Color(c1.r * p1 + c2.r * p2, c1.g * p1 + c2.g * p2, c1.b * p1 + c2.b * p2, c1.a * p1 + c2.a * p2)
	
end

function AverageColors(c1, c2)
	
	return BlendColors(c1, c2, 0.5)

end

function ColorFromHex(hex)
	
	if(hex:sub(1,1) ~= "#") then return end
	hex = hex:sub(2)
	local r, g, b = tonumber(hex:sub(1,2), 16), tonumber(hex:sub(3,4), 16), tonumber(hex:sub(5,6), 16)
	return Color(r, g, b, 255)
	
end

function NewPaletteFromHex(...)
	
	local arg = {...}
	local palette = {}
	for k, hex in pairs(arg) do
		palette[k] = ColorFromHex(hex)
	end
	
	return palette
	
end
