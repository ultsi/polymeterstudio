
function math.Limit(n, a, b)
	
	if(n < a) then return a
	elseif(n>b) then return b
	end
	
	return n
	
end

function math.AdvRound(a, d)

	d = d or 0
	return math.round( a * (10 ^ d) ) / (10 ^ d)
	
end

function math.IsWithin(a, b, c)
	
	return a >= b and a <= c

end
