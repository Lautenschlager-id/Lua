serialization = function(i,lastIndex)
	lastIndex = lastIndex or ""
	if type(i) == "table" then
		local out = ""
	
		for k,v in next,i do
			if type(v) == "string" then
				out = out .. string.format("@[%s]{%s}",string.format("%s[%s]",lastIndex,k),table.concat({string.byte(v,1,#v)},","))
			elseif type(v) == "number" then
				out = out .. string.format("#[%s]{%s}",string.format("%s[%s]",lastIndex,k),tostring(v))
			elseif type(v) == "boolean" then
				out = out .. string.format("![%s]{%s}",string.format("%s[%s]",lastIndex,k),tostring(v))
			elseif type(v) == "table" then
				out = out .. serialization(v,string.format("%s[%s]",lastIndex,k))
			end
		end

		return out
	elseif type(i) == "string" then
		local out = {}

		for t,k,v in string.gmatch(i,"([@#!])(%[.-%])%{(.-)%}") do
			print(string.format("%s %s %s",t,k,v))
			local value
			if t == "@" then
				value = string.char((function(bytes)
					local foo = {}
					for byte in string.gmatch(bytes,"[^,]+") do
						foo[#foo + 1] = tonumber(byte)
					end
					return table.unpack(foo)
				end)(v))
			elseif t == "#" then
				value = tonumber(v)
			elseif t == "!" then
				value = (v == "true")
			elseif t == "=" then
				value = serialization(v)
			end
			
			local index = {}
			for j in string.gmatch(k:sub(2,#k-1),"[^%[%]]") do
				index[#index + 1] = tonumber(j) or j
			end

			if #index == 1 then
				out[index[1]] = value
			else
				local m,n = 1
				while m <= #index do
					if not n then
						out[index[m]] = (out[index[m]] or {})
						n = out[index[m]]
						m = m + 1
					end

					n[index[m]] = (m ~= #index and (n[index[m]] or {}) or value)

					n = n[index[m]]
					m = m + 1
				end
			end
		end

		return out
	end
end
