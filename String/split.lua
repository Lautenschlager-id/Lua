string.split = function(value,pattern,f)
	local out = {}
	for v in string.gmatch(value,pattern) do
		out[#out + 1] = (f and f(v) or v)
	end
	return out
end
