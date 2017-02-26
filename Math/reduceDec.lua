math.reduceDec = function(x,n)
	local d = n and "1"..("0"):rep(n) or 100
	return math.floor(x*d)/d
end
