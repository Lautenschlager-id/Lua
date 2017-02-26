table.find = function(list,value,index)
	for k,v in next,list do
		if index then
			if v[index] == value then
				return true,k
			end
		else
			if v == value then
				return true,k
			end
		end
	end
	return false
end
