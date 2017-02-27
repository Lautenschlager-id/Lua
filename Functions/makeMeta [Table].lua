-- Creates a metatable enabling math with tables
-- x = makeMeta(x); x = x + 2

do
	local collect = function(a,b)
		if type(a) == "table" then return a,b else return b,a end
	end
	meta = {
		__add = function(v1,v2)
			v1,v2 = collect(v1,v2)
			local list,real = {},{}
			for i = 1,v2 do
				list[#v1 + i] = v1[i]
			end
			for i = 1,#v1+v2 do
				real[i] = (i<=#v1 and v1[i] or list[i])
			end
			return real
		end,
		__sub = function(v1,v2)
			v1,v2 = collect(v1,v2)
			local real = {}
			for k,v in next,v1 do
				if #real <= v2 then
					real[k] = v
				else
					break
				end
			end
			return real
		end,
		__mul = function(v1,v2)
			v1,v2 = collect(v1,v2)
			local real = {}
			for i = 1,v2 do
				for k,v in next,v1 do
					real[#real + 1] = v
				end
			end
			return real
		end,
		__unm = function(v1)
			local real = {}
			for k,v in next,v1 do
				if type(tonumber(v)) == "number" then
					real[k] = -v
				else
					real[k] = v
				end
			end
			return real
		end
	}
	makeMeta = function(list)
		return setmetatable(list,meta)
	end
end
