brainfuck = {}

brainfuck.errorC = {
	[1] = "Closing brackets are missed!",
	[2] = "Openin brackets are missed!",
	[3] = "No source!",
	[4] = "Unknown error"
}

brainfuck.verify = function(s)
	local error,l = 0,0
	for i = 1,#s,1 do
		if s:byte(i) == 91 then
			l = l + 1
		elseif s:byte(i) == 93 then
			l = l - 1
			if l < 0 then
				return 2
			end
		end
	end
	if l > 0 then
		return 1
	elseif l < 0 then
		return 2
	else
		return 0
	end
end

brainfuck.error = function(x)
	error(brainfuck.errorC[x or 4])
end

brainfuck.token = function(s)
	local size,max,m,p,l = 3e4,255,{},0,0,0
	local toReturn = {}
	for i = 0,size,1 do
		m[i] = 0
	end
	i = 0
	while i <= #s do
		i = i + 1
		if s:byte(i) == 43 then
			if m[p] < max then
				m[p] = m[p] + 1
			end
		elseif s:byte(i) == 45 then
			if m[p] > 0 then
				m[p] = m[p] - 1
			end
		elseif s:byte(i) == 44 then
			local copy = s:match("(.-)\n")
			m[p] = copy:byte(1)
		elseif s:byte(i) == 46 then
			table.insert(toReturn,tostring(m[p]):char())
		elseif s:byte(i) == 60 then
			p = p - 1
			if p < 0 then
				p = 0
			end
		elseif s:byte(i) == 62 then
			p = p + 1
			if p > size then
				p = size
			end
		elseif s:byte(i) == 91 then
			if m[p] == 0 then
				while s:byte(i)~=93 or l>0 do
					i = i + 1
					if s:byte(i) == 91 then
						l = l + 1
					end
					if s:byte(i) == 93 then
						l = l - 1
					end
				end
			end
		elseif s:byte(i) == 93 then
			if m[p] ~= 0 then
				while s:byte(i)~=91 or l>0 do
					i = i - 1
					if s:byte(i) == 91 then
						l = l - 1
					end
					if s:byte(i) == 93 then
						l = l + 1
					end
				end
			end
		end
	end
	return table.concat(toReturn,nil,1,#toReturn-1)
end

brainfuck.compile = function(s)
	local error = brainfuck.verify(s)
	if error == 0 then
		return brainfuck.token(s)
	else
		brainfuck.error(error)
	end
end
