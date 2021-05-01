local RunService = game:GetService("RunService")

----------------------------------------
----- Constants ------------------------
----------------------------------------
local ORIGINS = {
	["~"] = game:GetService("ReplicatedStorage");
	["Server"] = game:GetService("ServerScriptService");
}

local PATH_SPLIT_PATTERN = "[^/]+"

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
	
	if start == nil then
		local firstPart = parts[1]
		local origin = ORIGINS[firstPart]
		
		if origin == nil then
			origin = game:GetService(firstPart)
			
			if origin == nil then
				error("Origin '"..firstPart.."' is not defined and is not a service.")
			end
		end
		
		level = origin
		table.remove(parts, 1)
	end
	
	for _, part in ipairs(parts) do
		level = level:WaitForChild(part)
	end
	
	return level
end

----------------------------------------
----- Load -----------------------------
----------------------------------------
local Loader = {}

local function Load(path, start)
	local object = Traverse(path, start)
	
	if object:IsA("ModuleScript") then
		return require(object)
	else
		return object
	end
end

setmetatable(Loader, {
	__call = function(_, path, start)
		return Load(path, start)
	end
})

return Loader
