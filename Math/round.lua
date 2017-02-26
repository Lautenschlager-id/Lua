math.round=function(x)
	local r = x%1
	return (x - (r>.5 and r-1 or r))
end
