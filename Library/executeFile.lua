execute={}

execute.getFile=function(file,format)
	file = assert(io.open(file,"r"),"The file "..file.." does not exist or you have not access")
	local formatModes = [[ Formats
		"*n" -> Returns the first number;
		"*a" -> Reads all the file;
		"*l/*L" -> First line;
		number -> Reads from 0 'till number (Must be int)
	]]
	if format~="*n" and format~="*a" and format~="*l" and format~="*L" and type(format)~="number" then error(formatModes) end
	format = format or "*a"
	local _file = file:read(format)
	file:close()
	return _file
end

execute.editFile=function(file,format,edition)
	if edition == nil then error("Edition needs a value") end
	if format == "r" then error("Format must be a edition mode") end
	local formatModes = [[ Formats
		"r" -> Read; --You cant use this one here.
		"w" -> Write mode;
		"a" -> Add mode;
		"r+" -> Att mode (Do not erase everything);
		"w+" -> Att mode (Erase everything);
		"a+" -> Add mode in the end of the file
	]]
	if format ~= "w" and format ~= "a" and format ~= "r+" and format ~= "w+" and format ~= "a+" then error(formatModes) end
	file = assert(io.open(file,format),"The file "..file.." does not exist or you have not access")
	file:write(edition);file:flush();file:close()
end
