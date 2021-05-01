local USE_RANGE = 15

local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local PlayerCharacter = Load "Utility.PlayerCharacter"

local SharedKnife = {}

function SharedKnife.CanCarve(player, part, pointOnPart)
	if part == nil then
		return false
	end
	
	if not PlayerCharacter.IsAlive(player) then
		return false
	end
	
	if player:DistanceFromCharacter(pointOnPart) > USE_RANGE then
		return false
	end
	
	-- TODO: Split into separate flag
	if DataAccessor.GetFromAncestors(part, "DenyGather") then
		return false
	end
	
	if not DataAccessor.Get(part, "WeldWood") then
		return false
	end
	
	return true
end

function SharedKnife.CanSlice(player, part, pointOnPart)
	if part == nil then
		return false
	end
	
	if not PlayerCharacter.IsAlive(player) then
		return false
	end
	
	if player:DistanceFromCharacter(pointOnPart) > USE_RANGE then
		return false
	end
	
	-- TODO: Split into separate flag
	if DataAccessor.GetFromAncestors(part, "DenyGather") then
		return false
	end
	
	if DataAccessor.Get(part, "SliceResult") == nil or DataAccessor.Get(part, "Slices") == nil or DataAccessor.Get(part, "Slices") <= 0 then
		return false
	end
	
	return true
end

return SharedKnife