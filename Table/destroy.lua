table.destroy=function(list,value)
	for k,v in next,list do
		if v == value then
			table.remove(list,k)
      break
		end
	end
end
