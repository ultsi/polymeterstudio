
function table.Copy(other)
	
	local t = {}
	for key, value in pairs(other) do
		if(type(value) == "table") then
			t[key] = table.Copy(value)
		else
			t[key] = value
		end
	end
	
	return t
	
end

function table.NewPropertyTable()
	
	local t = {AddProperty = table.AddProperty, SetProperty = table.SetProperty}
	return t
	
end

function table.AddProperty(tab, property, defValue)
	
	local pName = "p_"..property
	tab[pName] = defValue
	tab["Set"..property] = function(tab, newVal) tab[pName] = newVal end
	tab["Get"..property] = function(tab) return tab[pName] end
	
end

-- doesn't create the functions
function table.SetProperty(tab, property, value)

	local pName = "p_"..property
	tab[pName] = value
	
end

table.New = table.Copy
local oldconcat = table.concat

function table.concat(t, sep)

	t = table.ToString(t)
	return oldconcat(t, sep)
	
end

function table.ToString(other)
	
	local t = {}
	for k,v in pairs(other) do
		t[k] = tostring(v)
	end
	
	return t
	
end
	
function table.Move(tab, from, where)
	
	table.insert(tab, where, table.remove(tab, from))
	
end

function table.RemoveValue(tab, value)
	
	for k, v in pairs(tab) do
		if(v == value) then
			table.remove(tab, k)
			return true
 		end
	end
	return false
	
end

function table.Add(this, other)
	
	for key, value in pairs(other) do
		table.insert(this, value)
	end
	
	return this
	
end

function table.Merge(this, other)
	
	for key, value in pairs(other) do
		this[key] = value
	end
	
	return this
	
end

function table.Inherit(this, other)
	
	for key, value in pairs(other) do
		this[key] = this[key] or value
	end
	
	return this
	
end

function table.Count(t)

	local i = 0
	for key, value in pairs(t) do 
		i = i + 1 
	end
	
	return i
	
end

local function ripairs_iter(tab, i)
	i = i - 1
	local v = tab[i]
	if(v==nil) then return v end
	return i,v
end

function ReverseIPairs(tab)

	return ripairs_iter, tab, #tab+1
	
end
