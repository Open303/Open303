-- Handles resource respawning and cluster selection.


----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local resourceRoot = workspace.Resources



----------------------------------------
local regenmultiplier = game.ReplicatedStorage.ConfigValues.RegenMultiplier.Value

local DEFAULT_RESPAWN_TIME = game:GetService("RunService"):IsStudio() and 5 or 4 * 60

----------------------------------------
----- Variables ------------------------
----------------------------------------
local copies = {}

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function ChooseRandomChild(root)
	local children = root:GetChildren()
	
	if #children == 0 then
		return nil
	end
	
	math.randomseed(tick())
	
	return children[math.random(1, #children)]
end

local function ResolveCluster(cluster)
	local chosen = ChooseRandomChild(cluster)
	
	for _, child in ipairs(cluster:GetChildren()) do
		if child ~= chosen then
			child:Destroy()
		end
	end
	
	chosen.Parent = resourceRoot
end

local function RecursiveCall(root, func)
	func(root)
	
	for _, child in ipairs(root:GetChildren()) do
		RecursiveCall(child, func)
	end
end

local function Respawn(object)
	--print("PASS B "..regenmultiplier)
	regenmultiplier = game.ReplicatedStorage.ConfigValues.RegenMultiplier.Value
	local respawningCopy
	
	if copies[object] == nil then
		copies[object] = object:Clone()
		respawningCopy = object
	else
		local copy = copies[object]
		respawningCopy = copy:Clone()
		copies[respawningCopy] = copy
		
		wait(0)
		object:Destroy()
		respawningCopy.Parent = workspace
		respawningCopy:MakeJoints()
	end
	
	local connection
	connection = respawningCopy.ChildRemoved:connect(function()
		connection:disconnect()
		regenmultiplier = game.ReplicatedStorage.ConfigValues.RegenMultiplier.Value
		local restime = DataAccessor.Get(object, "RespawnTime")
		local respawnTime = DEFAULT_RESPAWN_TIME * regenmultiplier
		if restime ~= nil then
			respawnTime = restime * regenmultiplier
		end
		--print("BROKEN : "..regenmultiplier)
		wait(respawnTime)
		--print("FIXED : "..regenmultiplier)
		--print("RESTIME "..respawnTime)
		Respawn(respawningCopy)
	end)
end

----------------------------------------
----- Resources ------------------------
----------------------------------------
local clusterCount = 0

for _, child in ipairs(resourceRoot:GetChildren()) do
	if child:IsA("Folder") and child.Name == "Cluster" then
		ResolveCluster(child)
		clusterCount = clusterCount + 1
	end
end

print("[Resources] ~ Resolved "..clusterCount.." clusters.")

for _, child in ipairs(resourceRoot:GetChildren()) do
	--print("PASS A "..regenmultiplier)
	Respawn(child)
end