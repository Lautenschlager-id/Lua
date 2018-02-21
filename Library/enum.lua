local enum = function(list)
	local out = {}
	
	for index, value in next, list do
		if not out[value] then
			out[value] = index
		end
	end
	
	return setmetatable({}, {
		__call = function(t, index)
			return out[index]
		end,
		__index = function(t, index)
			return list[index]
		end,
		__pairs = function()
			return next, list
		end,
		__newindex = function()
			return
		end,
		__tostring = function()
			return "enum"
		end,
		__metatable = 'enum'
	})
end
