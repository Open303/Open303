local FILTER_RANGE = 15

local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local PlayerCharacter = Load "Utility.PlayerCharacter"

local SharedOilFilter = {}

function SharedOilFilter.CanFilter(player, part, pointOnPart)
	if part == nil then
		return false
	end
	
	if not PlayerCharacter.IsAlive(player) then
		return false
	end
	
	if player:DistanceFromCharacter(pointOnPart) > FILTER_RANGE then
		return false
	end
	
	-- TODO: Split into separate flag
	if DataAccessor.GetFromAncestors(part, "DenyGather") then
		return false
	end
	
	-- TODO: Generalize?
	if part.Name ~= "Crude Oil" then
		return false
	end
	
	return true
end

return SharedOilFilter