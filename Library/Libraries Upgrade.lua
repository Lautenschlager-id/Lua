do
	local byte = string.byte
	string.byte = function(str)
		return byte(str,1,#str)
	end

	local random = math.random
	math.random = function(...)
		local n = {...}
		if #n > 2 then
			return n[random(#n)]
		else
			return random(...)
		end
	end

	table.concat = function(list,sep,f)
		local txt = ""
		sep = sep or ""
		for k,v in next,list do
			txt = txt .. (f and f(k,v) or v) .. sep
		end
		return txt:sub(1,-1-#sep)
	end
end
