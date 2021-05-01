local Array = {}

function Array.SetToArray(set)
	local array = {}
	
	for key in pairs(set) do
		table.insert(array, key)
	end
	
	return array
end

function Array.Filter(array, filterFunc)
	local new = {}
	
	for _, value in ipairs(array) do
		if filterFunc(value) then
			table.insert(new, value)
		end
	end
	
	return new
end

function Array.Merge(array1, array2)
	local merged = {}
	
	for _, value in ipairs(array1) do
		table.insert(merged, value)
	end
	
	for _, value in ipairs(array2) do
		table.insert(merged, value)
	end
	
	return merged
end

function Array.AddMultiple(array, ...)
	for i = 1, select("#", ...) do
		table.insert(array, select(i, ...))
	end
end

return Array