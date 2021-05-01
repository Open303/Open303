local HARVEST_RANGE = 15

local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local PlayerCharacter = Load "Utility.PlayerCharacter"

local SharedHarvesting = {}

function SharedHarvesting.CanHarvest(player, tool, part, pointOnPart)
	if part == nil then
		return false
	end
	
	if not PlayerCharacter.IsAlive(player) then
		return false
	end
	
	if player:DistanceFromCharacter(pointOnPart) > HARVEST_RANGE then
		return false
	end
	
	if DataAccessor.Get(part, "OnFire") then
		return
	end
	
	if DataAccessor.GetFromAncestors(part, "EffectiveTool") ~= DataAccessor.Get(tool, "Tool.HarvesterType") then
		return false
	end
	
	if DataAccessor.GetFromAncestors(part, "Tier") > DataAccessor.Get(tool, "Tool.HarvestTier") then
		return false
	end
	
	return true
end

return SharedHarvesting