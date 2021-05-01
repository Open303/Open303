----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local SharedInventory = Load "StarterTools.Inventory.SharedInventory"
local Hierarchy = Load "Utility.Hierarchy"
local Array = Load "Utility.Array"
local String = Load "Utility.String"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local constructablesBin = workspace:WaitForChild("Constructables")

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function FindCraftingStations(root)
	local foundStations = {}
	
	Hierarchy.CallOnDescendants(root, function(object)
		if object:IsA("BasePart") then
			local stations = DataAccessor.Get(object, "CraftingStations")
			
			if stations and stations:len() > 0 then
				table.insert(foundStations, object)
			end
		end
	end)
	
	return foundStations
end

----------------------------------------
----- Shared Craft ---------------------
----------------------------------------
local SharedCraft = {}
SharedCraft.Recipes = Load "StarterTools.Craft.Recipes"

function SharedCraft.GetNearbyStations(player)
	local nearby = {}
	
	if player.Character == nil then
		return nearby
	end
	
	local playerCenter = player.Character:GetPrimaryPartCFrame().p
	local region = Region3.new(playerCenter - Vector3.new(50, 50, 50), playerCenter + Vector3.new(50, 50, 50))
	local parts = workspace:FindPartsInRegion3WithIgnoreList(region, { workspace.Terrain, workspace.Resources, workspace.Regions, workspace.Animals, player.Character }, 1000)
	
	for _, part in ipairs(parts) do
		local craftRange = DataAccessor.Get(part, "CraftingRange")
		local craftingStations = DataAccessor.Get(part, "CraftingStations")
		
		if craftRange ~= nil then
			if player:DistanceFromCharacter(part.Position) <= craftRange and craftingStations ~= nil then
				for station in craftingStations:gmatch("[^,]+") do
					nearby[station] = true
				end
			end
		end
	end
	
	return nearby
end

function SharedCraft.NearCraftingStation(player, stationName)
	if not stationName then
		return true
	end
	
	local playerCenter = player.Character:GetPrimaryPartCFrame().p
	local region = Region3.new(playerCenter - Vector3.new(50, 50, 50), playerCenter + Vector3.new(50, 50, 50))
	local parts = workspace:FindPartsInRegion3WithIgnoreList(region, { workspace.Terrain, workspace.Resources, workspace.Regions, workspace.Animals, player.Character }, 1000)
	
	for _, part in ipairs(parts) do
		local craftRange = DataAccessor.Get(part, "CraftingRange")
		local craftingStations = DataAccessor.Get(part, "CraftingStations")
		
		if craftRange ~= nil and craftingStations ~= nil then
			if player:DistanceFromCharacter(part.Position) <= craftRange and craftingStations:find(stationName) then
				return true
			end
		end
	end
	
	return false
end

function SharedCraft.HasIngredientsFor(player, recipe)
	local playerInventory = SharedInventory.GetPlayerInventory(player)
	
	local totalIngredients = 0
	for _, count in pairs(recipe.Ingredients) do
		totalIngredients = totalIngredients + count
	end
	if totalIngredients == 0 then
		return true
	end
	
	if #playerInventory:GetChildren() < totalIngredients then
		return false
	end
	
	local items = playerInventory:GetChildren()
	for _, item in ipairs(items) do
		if recipe.Ingredients[item.Name] ~= nil then
			totalIngredients = totalIngredients - 1
			
			if totalIngredients == 0 then
				return true
			end
		end
	end
	
	return false
end

function SharedCraft.CanCraft(player, recipe)
	return SharedCraft.NearCraftingStation(player, recipe.CraftingStation) and SharedCraft.HasIngredientsFor(player, recipe)
end

return SharedCraft