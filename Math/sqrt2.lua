math.sqrt2=function(number,index,pow)
	if number then
		index,pow = index and (type(index)=="table" and index or {index}) or {2},pow and pow>2 and pow or 1
		local i = 1
		for k,v in next,index do
			i = i * v
		end
		return number^(pow/i)
	end
end
