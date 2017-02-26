text = "x adkt ndj cdl pcs udgtktg"
text = text:lower()

POTENCY = 25

frequency = {
	a =  0.08167,
	b =  0.01492,
	c =  0.02782,
	d =  0.04253,
	e =  0.12702,
	f =  0.02228,
	g =  0.02015,
	h =  0.06094,
	i =  0.06966,
	j =  0.00153,
	k =  0.00772,
	l =  0.04025,
	m =  0.02406,
	n =  0.06749,
	o =  0.07507,
	p =  0.01929,
	q =  0.00095,
	r =  0.05987,
	s =  0.06327,
	t =  0.09056,
	u =  0.02758,
	v =  0.00978,
	w =  0.02360,
	x =  0.00150,
	y =  0.01974,
	z =  0.00074,
}

string.rotate = function(str,i)
	local newStr = ""
	for k = 1,#str do
		local b = str:byte(k)
		if b ~= 32 then
			b = 97 + (((b - 97) + i) % 26)
		end
		newStr = newStr .. string.char(b)
	end
	return newStr
end


string.letterFrequency = function(str)
	local freq = {}
	for i = 1,#str do
		local letter = str:sub(i,i)
		if letter ~= " " then
			freq[letter] = (freq[letter] and freq[letter]+1 or 1)
		end
	end
	for k,v in next,freq do
		freq[k] = v / #str
	end
	return freq
end


string.compatibility = function(foo)
	local d = 0
	for k,v in next,frequency do
		if foo.lfreq[k] then
			d = d + math.abs(foo.lfreq[k] - v)
		end
	end
	return 1-d
end

io.write("Sentence: "..text.."\nPotency: "..POTENCY.."\n")

txtformat = "@Rotation: %d\n\t#Sentence: %s\n\t#Compatibility: %.18f%%\n"

solve = {}
solution = {
	rotation = 0,
	compatibility = 0
}
for i = 1,POTENCY do
	solve[i] = {}

	solve[i].txt = string.rotate(text,i)

	solve[i].lfreq = string.letterFrequency(solve[i].txt)

	solve[i].compatibility = string.compatibility(solve[i])

	if solution.compatibility < solve[i].compatibility then
		io.write("\n$BEAT "..i.."\n")
		solution = {
			rotation = i,
			compatibility = solve[i].compatibility
		}
	end

	io.write(txtformat:format(i,solve[i].txt,solve[i].compatibility))
end

io.write("\n>> BEST\n\t" .. txtformat:format(solution.rotation,solve[solution.rotation].txt,solution.compatibility))

os.execute("pause >nul")
