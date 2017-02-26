loadTable = function(s)
	local list
	for tbl in s:gmatch("[^%.]+") do
		tbl = tonumber(tbl) and tonumber(tbl) or tbl
		list = (list and list[tbl] or _G[tbl])
	end
	return list
end
