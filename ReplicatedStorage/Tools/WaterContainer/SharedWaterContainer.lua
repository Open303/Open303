local USE_RANGE = 15

local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local PlayerCharacter = Load "Utility.PlayerCharacter"

local SharedWaterContainer = {}

function SharedWaterContainer.CanFill(player, tool, part, pointOnPart)
	if part == nil then
		return false
	end
	
	if not PlayerCharacter.IsAlive(player) then
		return false
	end
	
	if player:DistanceFromCharacter(pointOnPart) > USE_RANGE then
		return false
	end
	
	if DataAccessor.Get(tool, "Tool.StoredAmount") >= DataAccessor.Get(tool, "Tool.MaximumAmount") then
		return false
	end
	
	-- TODO: Generalize.
	if part.Name ~= "Water" or DataAccessor.Get(part, "Edible.Portions") == nil or DataAccessor.Get(part, "Edible.Portions") <= 0 then
		return false
	end
	
	return true
end

function SharedWaterContainer.CanWet(player, tool, part, pointOnPart)
	if part == nil then
		return false
	end
	
	if not PlayerCharacter.IsAlive(player) then
		return false
	end
	
	if player:DistanceFromCharacter(pointOnPart) > USE_RANGE then
		return false
	end
	
	if DataAccessor.Get(tool, "Tool.StoredAmount") <= 0 then
		return false
	end
	
	if DataAccessor.Get(part, "OnFire") then
		return true
	end
	
	if DataAccessor.Get(part, "Flammable") then
		return true
	end
	
	if DataAccessor.Get(part, "WetsTo") ~= nil then
		return true
	end
	
	return false
end

return SharedWaterContainer