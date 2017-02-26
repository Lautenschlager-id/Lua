table.random=function(t)
	return (type(t)=="table" and t[math.random(#t)] or math.random())
end
