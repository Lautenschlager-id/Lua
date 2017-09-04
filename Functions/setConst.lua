do
	local _C = {}
	setConst = function(var,val)
		if not _C[var] then
			_C[var] = val
		end
		return nil
	end
	_G = setmetatable(_G,{
		__newindex = function(l,i,v)
			if _C[i] then
				rawset(l,i,nil)
				return _C[i]
			else
				rawset(l,i,v)
			end
		end,
		__index = function(l,i)
			return _C[i] or rawget(l,i)
		end
	})
end
