math.intToRoman=function(int)
	if int<1 or int>3999 then error("Int must be a number between 1 and 3999") end
	local romans = {"M","CM","D","CD","C","XC","L","XL","X","IX","V","IV","I"}
	local arabics = {1000,900,500,400,100,90,50,40,10,9,5,4,1}
	local result = ""
	for i = 1,#arabics do
		local count = math.floor(tonumber(int/arabics[i]))
		result = result .. romans[i]:rep(count)
		int = int - (arabics[i] * count)
	end
	return result
end

math.romanToInt=function(str)
	str = str:upper()
	local nums = {M=1000,D=500,C=100,L=50,X=10,V=5,I=1}
	local int = 0
	for i = 1,#str do
		local value = nums[str:sub(i,i)]
		if i+1 < #str and nums[str:sub(i+1,i+1)] > value then
			int = int - value
		else
			int = int + value
		end
	end
	return int
end
