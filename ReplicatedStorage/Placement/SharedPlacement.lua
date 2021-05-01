----------------------------------------
----- Constants ------------------------
----------------------------------------
local PLACE_RANGE = 75

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local Hierarchy = Load "Utility.Hierarchy"
local Regions = Load "Utility.Regions"

----------------------------------------
----- Shared Placement -----------------
----------------------------------------
local SharedPlacement = {}

function SharedPlacement.CanPlace(player, structure, part, point)
	if player.Character == nil or player.Character:FindFirstChild("Humanoid") == nil or player.Character.Humanoid.Health <= 0 then
		return false
	end
	
	if Regions.IsPointInRegion(point, "NoPlace") then
		return false
	end
	
	if player:DistanceFromCharacter(point) > PLACE_RANGE then
		return false
	end
	
	if part == nil then
		return false
	end
	
	if part == workspace.Terrain and not DataAccessor.Get(structure, "PlaceOnWater") then
		return false
	end
	
	if DataAccessor.Get(structure, "PlaceOnWater") and part ~= workspace.Terrain then
		return false
	end
	
	return true
end

function SharedPlacement.GetOffset(model)
	if DataAccessor.Get(model, "Vehicle") == true then
		return Vector3.new(0, 2, 0)
	end
	
	return Vector3.new(0, 0, 0)
end

return SharedPlacement