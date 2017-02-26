getTime = function(time)
	if type(time) ~= "number" then return "?" end

	local info = {}
	local n = {}

	local h = 60 * 60
	local d = h * 24
	local we = d * 7
	local mo = d * 30.41666
	local y = d * 365

	n[1] = {"years",time / y}
	n[2] = {"months",(time % y) / mo}
	n[3] = {"weeks",((time % y) % mo) / we}
	n[4] = {"days",(((time % y) % mo) % we) / d}
	n[5] = {"hours",((((time % y) % mo) % we) % d) / h}
	n[6] = {"minutes",time / 60 % 60}
	n[7] = {"seconds",time % 60}

	for i,v in next,n do
		v[2] = math.floor(v[2])
		if v[2] > 0 then
			info[math.min(#info + 1,i)] = v[2] .. " " .. v[1]:sub(1,-(v[2] == 1 and 2 or 1))
		end
	end

	return table.concat(info,", ")
end
