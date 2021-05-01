----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local Array = Load "Utility.Array"
local Hierarchy = Load "Utility.Hierarchy"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local constructablesBin = workspace:WaitForChild("Constructables")
local baseConstructablesBin = Load "Constructables"

----------------------------------------
----- Shared Buildings -----------------
----------------------------------------
local SharedBuildings = {}

SharedBuildings.ConstructableAdded = constructablesBin.ChildAdded
SharedBuildings.ConstructableRemoved = constructablesBin.ChildRemoved

function SharedBuildings.GetOwnedBuildings(player)
	local owned = {}
	
	for _, constructable in ipairs(constructablesBin:GetChildren()) do
		if DataAccessor.Get(constructable, "OwnerString") == player.Name and DataAccessor.Get(constructable, "Vehicle") ~= true then
			table.insert(constructable, owned)
		end
	end
	
	return owned
end

function SharedBuildings.IsBuilding(constructable)
	if constructable == nil then
		return false
	end
	
	return not DataAccessor.Get(constructable, "Vehicle")
end

function SharedBuildings.IsDestroyed(constructable)
	local baseModel = baseConstructablesBin:FindFirstChild(constructable.Name)
	local baseParts = #Array.Filter(
		Hierarchy.GetDescendants(baseModel), 
		function(object)
			return object:IsA("BasePart") 
		end
	)
	
	-- Account for BOUNDINGBOX
	baseParts = baseParts - 1
	
	--[[
	local foragU = constructable:FindFirstChild("Foragables")
	
	if foragU ~= nil then
		local foragL = foragU:FindFirstChild("Forage")
		if foragL ~= nil then
			local foragablespresent = foragL:GetChildren()
			baseParts = baseParts + #foragablespresent
		end
	end
	--]]
	local presentParts = #Array.Filter(
		Hierarchy.GetDescendants(constructable),
		function(object)
			return object:IsA("BasePart") and object.Name ~= "Egg" and object.Name ~= "Boulder"
		end
	)
	
	return baseParts ~= presentParts
end

return SharedBuildings