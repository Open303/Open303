-- Deprecated
-- Please use Import instead

----------------------------------------
----- Constants ------------------------
----------------------------------------
local DEFAULT_ROOT = game.ReplicatedStorage
local EXCEPTIONS = {
	--These are the LoadLibrary scripts - if I was less lazy I could probably seemlessly integrate them into the default root and they
	--wouldn't need to be exceptions at all.
	Create = function()
		return require(game:GetService("ReplicatedStorage"):WaitForChild("LoadLibrary"):WaitForChild("RbxUtility")).Create
	end;
	
	RbxGui = function()
		return require(game:GetService("ReplicatedStorage"):WaitForChild("LoadLibrary"):WaitForChild("RbxGui"))
	end;
	
	RbxUtility = function()
		return require(game:GetService("ReplicatedStorage"):WaitForChild("LoadLibrary"):WaitForChild("RbxUtility"))
	end;
}

local PATH_SPLIT_PATTERN = "[^%.]+"

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function SplitPath(path)
	local parts = {}
	
	for part in path:gmatch(PATH_SPLIT_PATTERN) do
		table.insert(parts, part)
	end
	
	return parts
end

local function Traverse(path, start)
	local level = start
	local parts = SplitPath(path)
	
	for _, part in ipairs(parts) do
		level = level:WaitForChild(part)
	end
	
	return level
end

----------------------------------------
----- Load -----------------------------
----------------------------------------
local function Load(path, start)
	start = start or DEFAULT_ROOT
	
	if EXCEPTIONS[path] then
		return EXCEPTIONS[path]()
	else
		local object = Traverse(path, start)
		
		if object:IsA("ModuleScript") then
			return require(object)
		else
			return object
		end
	end
end

return Load