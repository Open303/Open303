local MILK_RANGE = 15

local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local PlayerCharacter = Load "Utility.PlayerCharacter"

local SharedMilker = {}

function SharedMilker.CanMilk(player, part, pointOnPart)
	if part == nil then
		return false
	end
	
	if not PlayerCharacter.IsAlive(player) then
		return false
	end
	
	if player:DistanceFromCharacter(pointOnPart) > MILK_RANGE then
		return false
	end
	
	-- TODO: Generalize?
	if part.Name ~= "Udder" or part.Parent.Name ~= "Cow" then
		return false
	end
	
	return true
end

return SharedMilker