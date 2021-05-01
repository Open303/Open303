local BIN_RANGE = 15

local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local PlayerCharacter = Load "Utility.PlayerCharacter"

local SharedCheeseBin = {}

function SharedCheeseBin.CanBin(player, part, pointOnPart)
	if part == nil then
		return false
	end
	
	if not PlayerCharacter.IsAlive(player) then
		return false
	end
	
	if player:DistanceFromCharacter(pointOnPart) > BIN_RANGE then
		return false
	end
	
	-- TODO: Split into separate flag
	if DataAccessor.GetFromAncestors(part, "DenyGather") then
		return false
	end
	
	-- TODO: Generalize?
	if part.Name ~= "Young Cheese" then
		return false
	end
	
	return true
end

return SharedCheeseBin