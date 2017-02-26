math.color=function(x)
	if type(x) == "string" then
		return tonumber(x,16)
	elseif type(x) == "number" then
		return string.format("%x",x)
	end
end
