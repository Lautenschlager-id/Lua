system.players = function(alivePlayers)
	local alive,total = 0,0
	if alivePlayers then
		alive = {}
	end
	for k,v in next,tfm.get.room.playerList do
		if system.isPlayer(k) then
			if not v.isDead and not v.isVampire then
				if alivePlayers then
					alive[#alive + 1] = k
				else
					alive = alive + 1
				end
			end
			total = total + 1
		end
	end
	if alivePlayers then
		return alive
	else
		return alive,total
	end
end
