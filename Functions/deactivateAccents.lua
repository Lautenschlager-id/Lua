deactivateAccents=function(str)
	local letters = {a = {"á","â","à","å","ã","ä"},e = {"é","ê","è","ë"},i = {"í","î","ì","ï"},o = {"ó","ô","ò","õ","ö"},u = {"ú","û","ù","ü"}}
	for k,v in next,letters do
		for i = 1,#v do
			str = str:gsub(v[i],tostring(k))
		end
	end
	return str
end
