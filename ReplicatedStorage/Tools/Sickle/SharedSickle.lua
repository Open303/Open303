local Sickle_RANGE = 15

local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local PlayerCharacter = Load "Utility.PlayerCharacter"

function Set (list)
	local set = {}
	for _, l in ipairs(list) do set[l] = true end
	return set
end

local SharedSickle = {}

function SharedSickle.CanSickle(player, tool, part, pointOnPart)
	
	local NAME = part.Name
	local SICKLECHECK = DataAccessor.Get(part.Parent, "AllowHarvest")	
	
	if part == nil then
		return false
	end
	
	if player:DistanceFromCharacter(pointOnPart) > Sickle_RANGE then
		return false
	end
	
	if DataAccessor.Get(part, "OnFire") then
		return
	end

	if SICKLECHECK == nil then
		return
	end

	return true
end

return SharedSickle