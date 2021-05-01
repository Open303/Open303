----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"

----------------------------------------
----- Damage ---------------------------
----------------------------------------
local function Damage(humanoid, amount, damageType)
	if damageType == nil then
		humanoid:TakeDamage(amount)
	else
		local character = humanoid.Parent
		local armor = character:FindFirstChild("ACTIVEARMOR")
		local damageReduction = 1
		
		if armor ~= nil then
			local armorEffectiveness = DataAccessor.Get(armor, damageType.."Block")
			local percentEffectiveness = (armorEffectiveness or 0) / 100
			damageReduction = 1 - percentEffectiveness
		end
		
		local modifiedDamage = amount * damageReduction
		humanoid:TakeDamage(modifiedDamage)
	end
end

return Damage