----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local SharedCraft = Load "StarterTools.Craft.SharedCraft"
local SharedInventory = Load "StarterTools.Inventory.SharedInventory"
local Recipes = Load "StarterTools.Craft.Recipes"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local remoteCraftAttempt = Load "StarterTools.Craft.CraftAttempt"
local nte = Load "StarterTools.Craft.NewTool"

----------------------------------------
----- Variables ------------------------
----------------------------------------
local craftLocks = {}

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function CraftAttempt(player, id)
	local recipe = Recipes[id]
	
	if not recipe then
		warn("Recipe @ ID "..id.." is nil - recipe table has desynchronized! Player: "..player.Name)
		return false
	end
	
	local canCraft = SharedCraft.CanCraft(player, recipe)
	
	if not canCraft then
		print("Cannot craft")
		return false
	end
	
	if craftLocks[player] ~= nil then
		while craftLocks[player] ~= nil do
			wait(0)
		end
	end
	
	craftLocks[player] = tick()
	
	local inventory = SharedInventory.GetPlayerInventory(player)
	for ingredient, quantity in pairs(recipe.Ingredients) do
		for i = 1, quantity do
			local item = inventory:FindFirstChild(ingredient)
			
			-- weird race conditionals
			if item == nil or item.Parent == nil then
				craftLocks[player] = nil
				return false
			else
				item:Destroy()
			end
		end
	end
	
	local parent = recipe.Result:IsA("Tool") and player:WaitForChild("Backpack") or SharedInventory.GetPlayerInventory(player)
	
	for i = 1, recipe.Quantity do
		local object = recipe.Result:Clone()
		object.Parent = parent
	end
	
	craftLocks[player] = nil
	
	return true
end

----------------------------------------
----- Server Craft ---------------------
----------------------------------------
remoteCraftAttempt.OnServerInvoke = CraftAttempt