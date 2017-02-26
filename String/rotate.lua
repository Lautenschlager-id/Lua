string.rotate = function(str,rotation,lettersOnly)
	if lettersOnly then
		local b,c
		local newStr = {}
		for i = 1,#str do
			b = str:sub(i,i):byte()
			c = (b > 96 and b < 123) and 97 or (b > 64 and b < 91) and 65 or false
			if c then
				newStr[#newStr + 1] = string.char((c + (((b - c) + rotation) % 26)))
			end
		end
		return table.concat(newStr)
	else
		str = str:gsub("(.)",function(c)
			return string.char(c:byte() + rotation)
		end)
		return str
	end
end
