-- Makes a decimal number a fraction (String)

local cfact = function(x)
	local num,den = x:match("(%d+)/(%d+)")
	num,den = tonumber(num),tonumber(den)
	while den ~= 0 do
		local t = den
		den = num%den
		num = t
	end
	return num
end

local isInteger = function(x)
	return math.floor(x) - x == 0
end

local simplify = function(x)
	local num,den = x:match("(%d+)/(%d+)")
	local f = cfact(x)
	local n,d = num/f,den/f
	if isInteger(n/d) then
		return n/d
	else
		return n.."/"..d
	end
end

math.reduceDec = function(x,n)
	local d = n and "1"..("0"):rep(n) or 100
	return math.floor(x*d)/d
end

math.toFraction = function(x,reduce)
	if reduce then
		x = math.reduceDec(x,1)
	end
	local int,dec = math.modf(x)
	if dec == 0 then
		return x
	else
		local numb,frac = tostring(x):match("(%d+)%.(%d+)")
		local fracDen = "1" .. ("0"):rep(#frac)
		local result = numb..frac.."/"..fracDen
		return simplify(result)
	end
end
