----------------------------------------
----- Constants ------------------------
----------------------------------------
local CATEGORY_CLOSED_HEIGHT = 30
local RECIPE_ENTRY_HEIGHT = 70
local RECIPE_ENTRY_PADDING = 5
local DEFAULT_RANGE = 15

local ACTIVE_COLOR = Color3.fromRGB(96, 125, 139)
local INACTIVE_COLOR = Color3.fromRGB(131, 137, 139)

local MIN_INVENTORY_CHANGE_UPDATE_INTERVAL = 0.01
local DOUBLE_PRESS_TIME = 0.3

local CRAFT_HOTKEY_NAME = "CraftingCraftSelected"

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local SharedCraft = Load "StarterTools.Craft.SharedCraft"
local SharedInventory = Load "StarterTools.Inventory.SharedInventory"
local DataAccessor = Load "Data.DataAccessor"
local String = Load "Utility.String"
local Hierarchy = Load "Utility.Hierarchy"
local Recipes = Load "StarterTools.Craft.Recipes"
local UDim4 = Load "UI.UDim4"
local Scaffold = Load "UI.Scaffolder"
local PlayerCharacter = Load "Utility.PlayerCharacter"
local Colors = Load "UI.Colors"
local FunctionRunner = Load "Animation.FunctionRunner"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local StarterGui = game:GetService("StarterGui")

local localPlayer = game.Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local playerInventory = SharedInventory.GetPlayerInventory(localPlayer)
local tool = script.Parent

local craftScaffold = Load "StarterTools.Craft.CraftGuiScaffold"
local recipeEntryScaffold = Load "StarterTools.Craft.RecipeEntryScaffold"
local categoryLabelScaffold = Load "StarterTools.Craft.CategoryScaffold"
local craftContainer = Scaffold(craftScaffold)
local getanewtool = craftContainer:FindOnPath("OLDTOOLBUTTON")
local searchButton = craftContainer:FindOnPath("Top.Search.SearchButton")
local searchBox = craftContainer:FindOnPath("Top.Search.SearchBox")
local recipeButtonList = craftContainer:FindOnPath("ListContainer.RecipeList")
local noRecipesHint = craftContainer:FindOnPath("ListContainer.NoRecipesHint")
local recipeFrame = craftContainer:FindOnPath("CraftingInfo.Recipe")
local noRecipeFrame = craftContainer:FindOnPath("CraftingInfo.NoRecipe")
local recipeDisplayName = craftContainer:FindOnPath("CraftingInfo.Recipe.DisplayName")
local recipeTagline = craftContainer:FindOnPath("CraftingInfo.Recipe.Tagline")
local recipeIngredients = craftContainer:FindOnPath("CraftingInfo.Recipe.Ingredients")
local recipeStation = craftContainer:FindOnPath("CraftingInfo.Recipe.CraftingStation")
local craftButton = craftContainer:FindOnPath("CraftingInfo.Recipe.CraftButton")
local cannotCraft = craftContainer:FindOnPath("CraftingInfo.Recipe.CraftFailureReason")
local plusIndicator = craftContainer:FindOnPath("CraftingInfo.Recipe.CraftButton.PlusIndicator")

local remoteCraftAttempt = Load "StarterTools.Craft.CraftAttempt"
local bindableHotkeyPressed = Load "Hotkeys.Interactions.HotkeyPressed"

local nte = Load "StarterTools.Craft.NewTool"

----------------------------------------
----- Variables ------------------------
----------------------------------------
local inventoryQuantities = setmetatable({}, {__index = function() return 0 end})
local recipeButtons = {}
local categoryLabels = {}
local categorizedRecipes = {}
local nearbyStations = {}
local selectedRecipe = nil
local hoveredRecipe = nil
local discoveredRecipes = _G.CraftDiscoveredRecipes
if discoveredRecipes == nil then
	_G.CraftDiscoveredRecipes = {}
	discoveredRecipes = _G.CraftDiscoveredRecipes
end
local lastInvChange = tick()

local pairs, ipairs = pairs, ipairs
local tick, delay = tick, delay

local colorPool = {
	Colors.Green,
	Colors.Orange,
	Colors.Purple,
	Colors.Teal,
}

local plusRunner = FunctionRunner.new(function(alpha)
	local transparency
	
	if alpha < 0.5 then
		transparency = 1 - (alpha * 2)
	else
		transparency = (alpha - 0.5) * 2
	end
	
	plusIndicator.TextTransparency = transparency
end, 0.25)

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function UpdateCraftingInfo()
	local displayedRecipe = hoveredRecipe or selectedRecipe
	
	noRecipeFrame.Visible = displayedRecipe == nil
	recipeFrame.Visible = displayedRecipe ~= nil
	
	if displayedRecipe ~= nil then
		recipeDisplayName.Text = displayedRecipe.DisplayName
		recipeTagline.Text = displayedRecipe.Tagline or ""
		recipeIngredients.Text = displayedRecipe.IngredientString
		
		if displayedRecipe.CraftingStation ~= nil then
			local startsWithVowel = displayedRecipe.CraftingStation:sub(1, 1):match("^aeiouy$") ~= nil
			
			recipeStation.Text = "Crafted at a"..(startsWithVowel and "n " or " ")..displayedRecipe.CraftingStation.." or better"
		else
			recipeStation.Text = "Crafted by hand"
		end
		
		local missing = {}
		local nearStation = displayedRecipe.CraftingStation == nil or nearbyStations[displayedRecipe.CraftingStation]
		
		for ingredient, quantity in pairs(displayedRecipe.Ingredients) do
			local missingAmount = quantity - inventoryQuantities[ingredient]
			
			if missingAmount > 0 then
				table.insert(missing, missingAmount.."x "..ingredient)
			end
		end
		
		cannotCraft.Visible = #missing > 0 or not nearStation
		craftButton.Visible = not (#missing > 0 or not nearStation)
		
		if #missing > 0 then
			cannotCraft.Text = "Missing "..table.concat(missing, ", ")
		elseif not nearStation then
			cannotCraft.Text = "Not near a "..displayedRecipe.CraftingStation.." or better"
		end
	end
end

local function HasIngredientsFor(recipe)
	for ingredient, quantity in pairs(recipe.Ingredients) do
		if inventoryQuantities[ingredient] < quantity then
			return false
		end
	end
	
	return true
end

local function UpdateNearbyCache()
	nearbyStations = SharedCraft.GetNearbyStations(localPlayer)
end

local function GetColor(name)
	local strucOBJ = game.ReplicatedStorage.Constructables:FindFirstChild(name)
	local actOBJ = game.ReplicatedStorage.Items:FindFirstChild(name)
	local val = 1
	
	if strucOBJ ~= nil and DataAccessor.Get(strucOBJ, "TYPE") ~= nil then
		if DataAccessor.Get(strucOBJ, "TYPE") == "Vehicle" then
			val = 4
		end
	elseif actOBJ ~= nil and DataAccessor.Get(actOBJ, "TYPE") ~= nil then
		if DataAccessor.Get(actOBJ, "TYPE") ~= "Item" then
			val = 3
		elseif DataAccessor.Get(actOBJ, "TYPE") ~= "Tool" then
			val = 2
		end
	end
	
	return colorPool[val]
end

--[[
	local function GetColor(name)
	local actOBJ = game.Repl
	
	for i = 1, name:len() do
		local char = name:sub(i, i)
		local byte = char:byte()
		
		if byte % 4 == 0 then
			byte = -byte
		end
		
		value = value + byte
	end
	
	return colorPool[]
end
--]]

local function SortRecipes(recipeA, recipeB)
	local hasCraftingStationA = recipeA.CraftingStation ~= nil
	local hasCraftingStationB = recipeB.CraftingStation ~= nil
	local nearStationA = not hasCraftingStationA or nearbyStations[recipeA.CraftingStation]
	local nearStationB = not hasCraftingStationB or nearbyStations[recipeB.CraftingStation]
	
	-- Put all the uncraftable (due to lack of station) results at the bottom.
	if nearStationB and not nearStationA then
		return false
	elseif nearStationA and not nearStationB then
		return true
	-- Then sort by name.
	else
		if recipeA.Result ~= recipeB.Result then
			return recipeA.Result.Name:lower() < recipeB.Result.Name:lower()
		elseif recipeA.IngredientString ~= recipeB.IngredientString then
			return recipeA.IngredientString:lower() < recipeB.IngredientString:lower()
		else
			return recipeA.ID < recipeB.ID
		end
	end
end

local function GetCategoryLabel(name)
	local label = categoryLabels[name]
	
	if label == nil then
		label = Scaffold(categoryLabelScaffold, {
			CategoryName = name;
		})
		
		label.Parent = recipeButtonList
		categoryLabels[name] = label
	end
	
	return label
end

local function Craft()
	if selectedRecipe == nil then
		return
	end
	
	if not HasIngredientsFor(selectedRecipe) then
		return
	end
	
	if selectedRecipe.CraftingStation ~= nil and not nearbyStations[selectedRecipe.CraftingStation] then
		return
	end
	
	craftButton.Active = false
	craftButton.AutoButtonColor = false
	craftButton.BackgroundColor3 = Colors.Gray
	craftButton:FindFirstChild("ButtonText").Text = "Waiting for server"
	local success = remoteCraftAttempt:InvokeServer(selectedRecipe.ID)
	craftButton.Active = true
	craftButton.AutoButtonColor = true
	craftButton.BackgroundColor3 = Colors.Blue
	craftButton:FindFirstChild("ButtonText").Text = "Craft"
	
	-- If the recipe is deselected between crafting and server returning, selectedRecipe will be nil
	if success and selectedRecipe ~= nil then
		plusIndicator.Text = "+"..selectedRecipe.Quantity
		plusRunner:Restart()
	end
	
	UpdateCraftingInfo()
end

local function GetRecipeButton(id)
	local button = recipeButtons[id]
	
	if button == nil then
		local recipe = Recipes[id]
		button = Scaffold(recipeEntryScaffold, {
			DisplayName = recipe.DisplayName;
			ResultName = recipe.Result.Name;
		})
		
		button.BackgroundColor3 = GetColor(recipe.Result.Name)
		
		button.MouseEnter:connect(function()
			hoveredRecipe = recipe
			UpdateCraftingInfo()
		end)
		
		button.MouseLeave:connect(function()
			if hoveredRecipe == recipe then
				hoveredRecipe = nil
				UpdateCraftingInfo()
			end
		end)
		
		local lastPress = tick()
		button.InputEnded:connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				local pressTime = tick()
				
				if pressTime - lastPress < DOUBLE_PRESS_TIME and selectedRecipe == recipe then
					Craft()
				else
					if selectedRecipe ~= nil then
						local currentButton = GetRecipeButton(selectedRecipe.ID)
						currentButton:FindFirstChild("ButtonText").Font = Enum.Font.SourceSans
					end
					
					if selectedRecipe ~= recipe then
						button:FindFirstChild("ButtonText").Font = Enum.Font.SourceSansBold
						selectedRecipe = recipe
					else
						selectedRecipe = nil
					end
					
					UpdateCraftingInfo()
				end
				
				lastPress = pressTime
			end
		end)
		
		button.Parent = recipeButtonList
		recipeButtons[id] = button
	end
	
	return button
end

local function MatchesSearch(recipe)
	return recipe.Result.Name:lower():find(searchBox.Text:lower(), 1, true) ~= nil
end

local function ReflowList()
	local x, y = 0, 0
	
	noRecipesHint.Visible = true
	
	for name, recipes in pairs(categorizedRecipes) do
		local categoryLabel = GetCategoryLabel(name)
		local hasRecipe = false
		local adjustedCategoryLabel = false
		local displayedCount = 0
		table.sort(recipes, SortRecipes)
		
		for index, recipe in ipairs(recipes) do
			local button = GetRecipeButton(recipe.ID)
			button.Visible = discoveredRecipes[recipe.ID] and MatchesSearch(recipe)
			
			if button.Visible then
				noRecipesHint.Visible = false
				
				if not adjustedCategoryLabel then
					hasRecipe = true
					adjustedCategoryLabel = true
					
					categoryLabel.Position = UDim4.new(0, 10, 0, y)
					x = 0
					y = y + categoryLabel.AbsoluteSize.Y
				end
				
				displayedCount = displayedCount + 1
				button.Position = UDim4.new(x, 0, 0, y)
			
				x = x + button.Size.X.X.Scale
				
				if x >= 1 then
					x = 0
					y = y + button.Size.Y.Y.Offset + 5
				end
			end
		end
		
		if displayedCount % 2 == 1 then
			-- TODO: correct
			y = y + 30
		end
		
		categoryLabel.Visible = hasRecipe
	end
	
	recipeButtonList.CanvasSize = UDim2.new(0, 0, 0, y)
end

local function DiscoverRecipes(addedItem)
	local addedItemName = addedItem.Name
	local discovered = 0
	local lastDiscovered = nil

	for id, recipe in ipairs(Recipes) do
		if recipe.Ingredients[addedItemName] ~= nil and not discoveredRecipes[recipe.ID] then
			discoveredRecipes[id] = true
			lastDiscovered = recipe
			discovered = discovered + 1
		end
	end
	
	local message
	
	if discovered > 0 then
		ReflowList()
		
		if discovered == 1 then
			message = "You learned a recipe for "..lastDiscovered.Result.Name.." from the "..addedItemName
		else
			message = "You learned "..discovered.." new recipes from the "..addedItemName
		end
	end
	
	if message ~= nil then
		StarterGui:SetCore("ChatMakeSystemMessage", {
			Text = message;
			Color = Color3.new(1, 1, 0);
		})
	end
end

local function BuildInventoryQuantities()
	for _, item in ipairs(playerInventory:GetChildren()) do
		inventoryQuantities[item.Name] = inventoryQuantities[item.Name] + 1
	end
end

----------------------------------------
----- Event Connectors -----------------
----------------------------------------
local function InventoryChange(direction)
	return function(item)
		inventoryQuantities[item.Name] = inventoryQuantities[item.Name] + direction
		DiscoverRecipes(item)
		
		local changeStamp = tick()
		
		delay(MIN_INVENTORY_CHANGE_UPDATE_INTERVAL, function()
			if lastInvChange == changeStamp then
				UpdateCraftingInfo()
			end
		end)
		
		lastInvChange = changeStamp
	end
end

local function OnEquipped()
	craftContainer.Visible = true
end

local function OnUnequipped()
	craftContainer.Visible = false
end

----------------------------------------
----- Client Craft ---------------------
----------------------------------------
BuildInventoryQuantities()
UpdateNearbyCache()

local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "CraftGui"
craftContainer.Parent = gui
craftContainer.Visible = false

-- Create category and recipe entries, and discover empty recipes.
for id, recipe in ipairs(Recipes) do
	-- Used by category update functions, which get their recipes from categorizedRecipes.
	recipe.ID = id
	
	local category = recipe.CraftingStation ~= nil and recipe.CraftingStation.." or better" or "By Hand"
	
	-- Initialize category array if it's missing
	if not categorizedRecipes[category] then
		GetCategoryLabel(category)
		categorizedRecipes[category] = {}
	end
	
	-- Categorize!
	table.insert(categorizedRecipes[category], recipe)
	
	-- Discover empty recipes:
	isEmpty = true
	for _,_ in pairs(recipe.Ingredients) do
		isEmpty = false
	end
	if isEmpty then
		discoveredRecipes[id] = true
	end
	
	GetRecipeButton(id)
end

ReflowList()
UpdateCraftingInfo()

tool.Equipped:connect(OnEquipped)
tool.Unequipped:connect(OnUnequipped)

playerInventory.ChildAdded:connect(InventoryChange(1))
playerInventory.ChildRemoved:connect(InventoryChange(-1))

searchBox.FocusLost:connect(function(enter)
	if enter then
		ReflowList()
	end
end)

searchButton.InputEnded:connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		ReflowList()
	end
end)

craftButton.InputEnded:connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		Craft()
	end
end)

bindableHotkeyPressed.Event:connect(function(hotkey)
	if craftContainer.Visible then
		if hotkey == CRAFT_HOTKEY_NAME then
			Craft()
		elseif hotkey == "SelectSearch" then
			wait(0)
			searchBox:CaptureFocus()
		end
	end
end)

getanewtool.InputEnded:connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		nte:FireServer()
	end
end)

local humanoid = PlayerCharacter.WaitForCurrentHumanoid(localPlayer)

humanoid.Died:connect(function()
	gui:Destroy()
end)

while wait(1) do
	UpdateNearbyCache()
	UpdateCraftingInfo()
end