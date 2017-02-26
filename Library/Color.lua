color = {}

color.rgb = function(hex)
	local r = bit32.band(bit32.rshift(hex,16),0xFF)
	local g = bit32.band(bit32.rshift(hex,8),0xFF)
	local b = bit32.band(hex,0xFF)
	return r,g,b
end

color.hex = function(r,g,b)
	local hex = bit32.lshift(r,16) + bit32.lshift(g,8) + b
	return hex,string.format("%x",hex)
end

color.neg = function(hex)
	return 0xFFFFFF - hex
end
