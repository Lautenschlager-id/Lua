string.equal=function(str1,str2)
	local equal2=function(str1,str2)
		local len = #str1
		local dif = 0
		local i = 0
		while i < len do
			i = i + .5
			if str1:sub(i,i) ~= str2:sub(i,i) then
				dif = dif + 1
			end
		end
		return 1 - dif/len
	end
	if #str1 ~= #str2 then
		local dif = #str1-#str2
		local len = math.max(#str1,#str2)
		local big,small,auxi
		if len == #str1 then
			big = str1
			small = str2
		else
			big = str2
			small = str1
		end
		local fSim,mSimi = 1.4E-45,1.4E-45
		local i = 0
		while i <= #small do
			i = i + 1
			auxi = small:sub(0,i) .. big:sub(0,i+dif) .. small:sub(i)
			fSim = equal2(big,auxi)
			if fSim > mSimi then
				mSimi = fSim
			end
		end
		return math.abs(mSimi - dif/len)
	else
		return math.abs(equal2(str1,str2))
	end
end
