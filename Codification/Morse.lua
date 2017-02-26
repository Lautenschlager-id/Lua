morse = {}
morse.code = {a=".-",b="-...",c="-.-.",d="-..",e=".",f="..-.",g="--.",h="....",i="..",j=".---",k="-.-",l=".-..",m="--",n="-.",o="---",p=".--.",q="--.-",r=".-.",s="...",t="-",u="..-",v="...-",w=".--",x="-..-",y="-.--",z="--..",[1]=".----",[2]="..---",[3]="...--",[4]="....-",[5]=".....",[6]="-....",[7]="--...",[8]="---..",[9]="----.",[0]="-----"}
morse.to = function(str)
	str = str:lower()
	str = str:gsub(" +"," / ")
	for i,v in next,morse.code do
		str = str:gsub(tostring(i),v.." ")
	end
	return str
end
morse.from = function(code)
	code = code:gsub("\n+"," ")
	local c = ""
	for k in code:gmatch("[^%s]+") do
		for i,j in next,morse.code do
			if k == j then
				c = c .. i
			elseif k == "/" then
				c = c .. " "
				break
			end
		end
	end
	return c
end
