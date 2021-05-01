local START_RANGE = 15

local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"

local SharedFireStarter = {}

function SharedFireStarter.CanIgnite(player, part, pointOnPart)
	if part == nil then
		return false
	end
	
	if player.Character == nil or player.Character:FindFirstChild("Humanoid") == nil or player.Character.Humanoid.Health <= 0 then
		return false
	end
	
	if player:DistanceFromCharacter(pointOnPart) > START_RANGE then
		return false
	end
	
	if DataAccessor.Get(part, "OnFire") == true then
		return false
	end
	
	return DataAccessor.Get(part, "Flammable") == true
end

return SharedFireStarter