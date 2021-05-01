----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local PlayerCharacter = Load "Utility.PlayerCharacter"

----------------------------------------
----- Shared Weapon --------------------
----------------------------------------
local SharedWeapon = {}

function SharedWeapon.CanAttack(player, tool, part, pointOnPart)
	local range = DataAccessor.Get(tool, "Tool.AttackRange")

	if part == nil then
		return false
	end

	if not PlayerCharacter.IsAlive(player) then
		return false
	end

	if player:DistanceFromCharacter(pointOnPart) > range then
		return false
	end

	if PlayerCharacter.GetHumanoidFromPart(part) == nil then
		return false
	end

	return true
end

return SharedWeapon