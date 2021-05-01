----------------------------------------
----- Constants ------------------------
----------------------------------------
local PLACEMENT_RANGE = 15
local REGION_NAME = "NoPlace"

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local Regions = Load "Utility.Regions"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local RunService = game:GetService("RunService")

local inventoryBin = Load "StarterTools.Inventory.Inventories"
local starterInventory = Load "StarterTools.Inventory.Starter"
local actionBin = Load "StarterTools.Inventory.PlacementActions"

----------------------------------------
----- Shared Inventory -----------------
----------------------------------------
local SharedInventory = {}

SharedInventory.PlacementRange = PLACEMENT_RANGE

function SharedInventory.GetPlayerInventory(player)
	if RunService:IsServer() then
		print("Server attempting to get inventory.")
		local inventory = inventoryBin:FindFirstChild(tostring(player.UserId))
		if inventory == nil then
			print("Server could not find inventory, creating new inventory.")
			inventory = starterInventory:Clone()
			inventory.Name = tostring(player.UserId)
			inventory.Parent = inventoryBin
		end
		
		return inventory
	else
		return inventoryBin:WaitForChild(tostring(player.UserId))
	end
end

function SharedInventory.CanPlaceAt(player, item, position)
	if item.Parent ~= SharedInventory.GetPlayerInventory(player) then
		return false
	end
	
	if player.Character == nil or player.Character:FindFirstChild("Humanoid") == nil then
		return false
	end
	
	if player.Character.Humanoid.Health <= 0 then
		return false
	end
	
	if player:DistanceFromCharacter(position) > PLACEMENT_RANGE then
		return false
	end
	
	if Regions.IsPointInRegion(position, REGION_NAME) then
		return false
	end
	
	return true
end

function SharedInventory.GetPlacementAction(item)
	local action = DataAccessor.Get(item, "PlaceAction")
	if action then
		if actionBin:FindFirstChild(action) then
			return require(actionBin:FindFirstChild(action))
		else
			error(item:GetFullName().." specifies a nonexistant placement action "..action)
		end
	end
	
	return nil
end

function SharedInventory.GetEquippedArmors(player)
	local character = player.Character
	
	local armors = {}
	
	if character ~= nil then
		for _, child in ipairs(character:GetChildren()) do
			if child:IsA("BasePart") and DataAccessor.Get(child, "ArmorName") ~= nil then
				table.insert(armors, child)
			end
		end
	end
		
	return armors
end

return SharedInventory