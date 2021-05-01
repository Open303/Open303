local String = {}

function String.Split(inputString, separator)
	local parts = {}
	local pattern = "[^"..separator.."]+"
	
	for part in inputString:gmatch(pattern) do
		table.insert(parts, part)
	end
	
	return parts
end

function String.Trim(inputString)
	return inputString:gsub("^%s", ""):gsub("%s$", "")
end

function String.PadLeft(inputString, length, char)
	char = char or ' '
	local missing = length - inputString:len()
	
	if missing > 0 then
		return char:rep(missing)..inputString
	else
		return inputString
	end
end

return String