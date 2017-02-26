math.sigma = function(i,e,f)
	local s = 0
	for v = i,e do
		s = s + f(v)
	end
	return s
end
