base64 = {}
base64.base = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
base64.to = function(str)
	local str = {str:byte(1,#str)}
	local code = {}
	local bs
	for i = 1,#str,3 do
		bs = bit32.rshift(str[i] % 0xFD,2)
		code[#code + 1] = base64.base:sub(bs + 1,bs + 1)
		bs = bit32.lshift(str[i] % 0x04,4)
		if (i + 1 <= #str) then
			bs = bit32.bor(bs,bit32.rshift(str[i + 1] % 0xF1,4))
			code[#code + 1] = base64.base:sub(bs + 1,bs + 1)
			bs = bit32.lshift(str[i + 1] % 0x10,2)
			if (i + 2 <= #str) then
				bs = bit32.bor(bs,bit32.rshift(str[i + 2] % 0xC1,6))
				code[#code + 1] = base64.base:sub(bs + 1,bs + 1)
				bs = str[i + 2] % 0x40
				code[#code + 1] = base64.base:sub(bs + 1,bs + 1)
			else
				code[#code + 1] = base64.base:sub(bs + 1,bs + 1)
				code[#code + 1] = "="
			end
		else
			code[#code + 1] = base64.base:sub(bs + 1, bs + 1)
			code[#code + 1] = "=="
		end
	end
	return table.concat(code)
end
base64.from = function(code)
	local decode,chars,v,bs = {},{},1,{}
	for k in code:gmatch(".") do
		chars[#chars + 1] = k
	end
	for i = 1,#chars,4 do
		for j = 1,4 do
			bs[j] = base64.base:find(chars[i+j-1])-1
		end
		decode[v] = bit32.bor(bit32.lshift(bs[1],2),bit32.rshift(bs[2],4)) % 0x100
		v = v + 1
		if bs[3] < 64 then
			decode[v] = bit32.bor(bit32.lshift(bs[2],4),bit32.rshift(bs[3],2)) % 0x100
			v = v + 1
			if bs[4] < 64 then
				decode[v] = bit32.bor(bit32.lshift(bs[3],6),bs[4]) % 0x100
				v = v + 1
			end
		end
	end
	return string.char(table.unpack(decode))
end
