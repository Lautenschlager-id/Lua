table.turnTable = function(x)
	return (type(x)=="table" and x or {x})
end
table.merge = function(this,src)
	for k,v in next,src do
		if this[k] then
			if type(v) == "table" then
				this[k] = table.turnTable(this[k])
				table.merge(this[k],v)
			else
				this[k] = this[k] or v
			end
		else
			this[k] = v
		end
	end
end
