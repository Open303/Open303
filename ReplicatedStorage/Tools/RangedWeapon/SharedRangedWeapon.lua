----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local SharedInventory = Load "StarterTools.Inventory.SharedInventory"
local PlayerCharacter = Load "Utility.PlayerCharacter"

----------------------------------------
----- Shared Weapon --------------------
----------------------------------------
local SharedWeapon = {}

function SharedWeapon.GetBestAmmo(player, tool)
	local toolAmmoType = DataAccessor.Get(tool, "Tool.AmmoType")
	local inventoryItems = SharedInventory.GetPlayerInventory(player):GetChildren()
	local best = nil
	local bestDamage = 0
	
	for _, item in ipairs(inventoryItems) do
		local ammoType = DataAccessor.Get(item, "AmmoType")
		
		if ammoType == toolAmmoType then
			local ammoDamage = DataAccessor.Get(item, "AmmoDamage")
			
			if ammoDamage > bestDamage then
				best = item
				bestDamage = ammoDamage
			end
		end
	end
	
	return best
end

function SharedWeapon.GetAllBestAmmo(player, tool)
	local bestAmmo = SharedWeapon.GetBestAmmo(player, tool)
	
	if bestAmmo == nil then
		return {}
	end
	
	local inventoryItems = SharedInventory.GetPlayerInventory(player):GetChildren()
	local bestAmmoType = DataAccessor.Get(bestAmmo, "AmmoType")
	local bestAmmoDamage = DataAccessor.Get(bestAmmo, "AmmoDamage")
	
	local ammos = {}
	
	for _, item in ipairs(inventoryItems) do
		if DataAccessor.Get(item, "AmmoType") == bestAmmoType and DataAccessor.Get(item, "AmmoDamage") == bestAmmoDamage then
			table.insert(ammos, item)
		end
	end
	
	return ammos
end

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
	
	if SharedWeapon.GetBestAmmo(player, tool) == nil then
		return false
	end
	
	return true
end

return SharedWeapon