table.find = function(list,value,index,f)
	for k,v in next,list do
		local i = (type(v) == "table" and index and v[index] or v)
		if (f and f(i) or i) == value then
			return true,k
		end
	end
	return false,0
end
