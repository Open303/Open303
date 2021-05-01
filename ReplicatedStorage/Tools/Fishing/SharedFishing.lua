----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"

----------------------------------------
----- Shared Fishing -------------------
----------------------------------------
local SharedWeapon = {}

function SharedWeapon.CanFish(player, tool, part, pointOnPart)
	local range = DataAccessor.Get(tool, "Tool.FishRange")
	
	if part == nil then
		return false
	end
	
	if part ~= workspace.Terrain then
		return false
	end
	
	if player:DistanceFromCharacter(pointOnPart) > range then
		return false
	end

	return true
end


return SharedWeapon