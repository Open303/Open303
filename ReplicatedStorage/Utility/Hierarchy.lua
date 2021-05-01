-- Utilities for manipulating and traversing the game hierarchy.

----------------------------------------
----- Hierarchy ------------------------
----------------------------------------
local Hierarchy = {}

function Hierarchy.GetDescendants(object, ignoreList)
	local descendants = {}
	local queue = {}
	
	for _, child in ipairs(object:GetChildren()) do
		table.insert(descendants, child)
		table.insert(queue, child)
	end
	
	while #queue > 0 do
		local object = queue[1]
		table.remove(queue, 1)
		
		local shouldIgnore = false
		
		if ignoreList ~= nil then
			for _, ignoreObject in ipairs(ignoreList) do
				if object == ignoreObject then
					shouldIgnore = true
					break
				end
			end
		end
		
		if not shouldIgnore then
			for _, child in ipairs(object:GetChildren()) do
				table.insert(descendants, child)
				table.insert(queue, child)
			end
		end
	end
	
	return descendants
end

function Hierarchy.CallOnDescendants(root, func)
	local descendants = Hierarchy.GetDescendants(root)
	for _, descendant in ipairs(descendants) do
		func(descendant)
	end
end

function Hierarchy.FindFirstInAncestors(start, name, stopPoint)
	stopPoint = stopPoint or workspace
	
	local level = start
	
	while true do
		local test = level:FindFirstChild(name)
		
		if test ~= nil then
			return test
		else
			level = level.Parent
			
			if level == stopPoint then
				break
			end
		end
	end
	
	return nil
end

return Hierarchy