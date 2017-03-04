do
	local langue = {
		af = {1123},
		ar = {1025,2049,3073,4097,5121,6145,7169,8193,9217,10241,11265,12289,13313,14337,15361,16385},
		bd = {2117},
		be = {1059},
		bg = {1026},
		bn = {1093},
		br = {1046},
		bw = {2098},
		cm = {1144,1152},
		cn = {4,1028,1105,2052,3076,4100,5124,31748},
		cz = {1029},
		da = {1030},
		de = {1031,2055,3079,4103,5127},
		el = {1032},
		en = {1033,1106,1141,1169,2057,3081,4105,5129,6153,7177,8201,9225,10249,11273,12297,13321,16393,17417,18441},
		er = {2163},
		es = {1027,1110,2051},
		et = {1061,1139},
		fa = {1065},
		fo = {1080},
		fr = {1154,1155,1156},
		ge = {1079},
		ha = {1128},
		id = {1057},
		["in"] = {1081,1094,1095,1096,1097,1111},
		it = {1040,2064},
		jp = {1041},
		ke = {1089},
		kg = {1088},
		km = {1107},
		ko = {1042},
		ku = {1170},
		lk = {2121},
		lo = {1108},
		lt = {1063},
		lv = {1062},
		mn = {1104,2128},
		mu = {1125},
		mz = {1153},
		ng = {1136},
		nl = {1043,1122,2067},
		nn = {2068},
		no = {1044},
		np = {1121},
		pa = {2118},
		ph = {1124},
		pl = {1045},
		pt = {2070},
		quc = {1158},
		rm = {1047},
		ro = {1048},
		ru = {1049,1092,1157},
		rw = {1159},
		sd = {1113,2137},
		sl = {1060},
		sn = {1160,2151},
		tg = {1064},
		ti = {2163},
		tk = {1090},
		tn = {1074},
		uk = {1058},
		ur = {1056,2080},
		uz = {1091,2115},
		xh = {1076},
		za = {1077,1078},
	}
	local languageLocale = io.popen("wmic os get oslanguage")
	languageLocale = languageLocale:read("*a")
	languageLocale = languageLocale:match("%d+")
	languageLocale = tonumber(languageLocale)
	
	for abbrv,codeList in next,langue do
		for id,code in next,codeList do
			if languageLocale == code then
				languageLocale = abbrv
				break
			end
		end
	end
	
	return (languageLocale and type(languageLocale) ~= "number" and languageLocale or "en")
end
