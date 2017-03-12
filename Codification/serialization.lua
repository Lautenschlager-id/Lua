serialization = function(x)
	if type(x) == "table" then
		local t = x
		local str = ""
		for index,value in next,t do
			local prefix,tbOption = (type(value)=="string" and "_@" or type(value)=="boolean" and "_!" or type(value)=="number" and "_#" or type(value)=="table" and "_%" or ""),(type(value)~="table" and tostring(value) or "+&"..serialization(value):gsub(";","?").."&-")
			str = str .. ':' .. tostring(index) .. prefix .. tbOption .. ";"
		end
		return str
	elseif type(x) == "string" then
		local s = x
		local list = {}
		for str in s:gmatch("(.-);") do
			local varName,valueType,value = str:match(':(.-)_(%p)(.+)')
			if varName~=nil then
				varName = tonumber(varName) or varName
				if valueType == "@" then
					list[varName] = tostring(value)
				elseif valueType == "!" then
					list[varName] = value=="true"
				elseif valueType == "#" then
					list[varName] = tonumber(value)
				elseif valueType == "%" then
					list[varName] = serialization(value:gsub("+&",""):gsub("&-",""):gsub("%?",";"))
				end	
			end
		end
		return list
	end
end
