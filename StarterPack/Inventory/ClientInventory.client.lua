----------------------------------------
----- Constants ------------------------
----------------------------------------
local PLACE_ALL_HOTKEY_NAME = "InventoryPlaceSelected"
local CONTINUE_PLACING_HOTKEY_NAME = "InventoryContinuePlace"

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local SharedInventory = Load "StarterTools.Inventory.SharedInventory"
local DataAccessor = Load "Data.DataAccessor"
local Hierarchy = Load "Utility.Hierarchy"
local Array = Load "Utility.Array"
local Create = Load "Create"
local Scaffold = Load "UI.Scaffolder"
local Colors = Load "UI.Colors"
local UDim4 = Load "UI.UDim4"
local Easings = Load "Animation.Easings"
local FunctionRunner = Load "Animation.FunctionRunner"
local PlayerCharacter = Load "Utility.PlayerCharacter"

----------------------------------------
----- Constants ------------------------
----------------------------------------
local DEFAULT_SEARCH_TEXT = "Search"
local DEFAULT_ACTION_HINT = "Click nearby to place the item."
local ITEM_ENTRY_HEIGHT = 30
local ITEM_ENTRY_PADDING = 5
local CLOSED_POSITION = UDim4.FromUDim2(UDim2.new(0.3, 0, 0.15, 0))
local OPEN_POSITION = UDim4.FromUDim2(UDim2.new(0.3, 0, 0.25, 0))
local PLACING_POSITION = UDim4.FromUDim2(UDim2.new(0.3, 0, 0.15, 0))
local LIST_SIZE_OPEN = UDim4.FromUDim2(UDim2.new(1, 0, 0.9, -5))
local LIST_SIZE_CLOSED = UDim4.FromUDim2(UDim2.new(1, 0, 0, 0))
local ZERO_POINT = UDim4.FromUDim2(UDim2.new(0, 0, 0, 0))
local DEFAULT_VIEW_HIDE_POSITION = UDim4.FromUDim2(UDim2.new(0, 0, -1, 0))
local PLACING_VIEW_HIDE_POSITION = UDim4.FromUDim2(UDim2.new(0, 0, 1, 0))

----------------------------------------
----- Objects --------------------------
----------------------------------------
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = game.Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local humanoid = PlayerCharacter.WaitForCurrentHumanoid(localPlayer)
local tool = script.Parent

local inventoryGuiScaffold = Load "StarterTools.Inventory.InventoryGuiScaffold"
local entryScaffold = Load "StarterTools.Inventory.EntryScaffold"

local inventoryGui = Scaffold(inventoryGuiScaffold)
local defaultView = inventoryGui:FindOnPath("Top.DefaultView")
local placingView = inventoryGui:FindOnPath("Top.PlacingView")
local itemListContainer = inventoryGui:FindOnPath("ItemListBackground")
local itemList = inventoryGui:FindOnPath("ItemListBackground.ItemList")
local searchBox = inventoryGui:FindOnPath("Top.DefaultView.Search.SearchBox")
local searchButton = inventoryGui:FindOnPath("Top.DefaultView.Search.SearchButton")
local removeArmorButton = inventoryGui:FindOnPath("Top.DefaultView.RemoveArmor")
local placementHint = inventoryGui:FindOnPath("Top.PlacingView.PlacementHint")
local cancelButton = inventoryGui:FindOnPath("Top.PlacingView.CancelPlacement")

local playerInventory = SharedInventory.GetPlayerInventory(localPlayer)

local remotePlaceAt = Load "StarterTools.Inventory.PlaceAt"
local remoteActionOn = Load "StarterTools.Inventory.ActionOn"
local remoteRemoveArmor = Load "StarterTools.Inventory.RemoveArmor"

local easer = Easings.EaseOut(3)

local startPlacingRunner = FunctionRunner.new(function(rawAlpha)
	local alpha = easer(rawAlpha * 0.25, 0.25)
	inventoryGui.Position = OPEN_POSITION:Lerp(PLACING_POSITION, alpha)
	itemListContainer.Size = LIST_SIZE_OPEN:Lerp(LIST_SIZE_CLOSED, alpha)
	itemListContainer.BorderSizePixel = 0
	defaultView.Position = ZERO_POINT:Lerp(DEFAULT_VIEW_HIDE_POSITION, alpha)
	placingView.Position = PLACING_VIEW_HIDE_POSITION:Lerp(ZERO_POINT, alpha)
end, 0.25)

local stopPlacingRunner = FunctionRunner.new(function(rawAlpha)
	local alpha = easer(rawAlpha * 0.25, 0.25)
	inventoryGui.Position = PLACING_POSITION:Lerp(OPEN_POSITION, alpha)
	itemListContainer.Size = LIST_SIZE_CLOSED:Lerp(LIST_SIZE_OPEN, alpha)
	itemListContainer.BorderSizePixel = 1
	defaultView.Position = DEFAULT_VIEW_HIDE_POSITION:Lerp(ZERO_POINT, alpha)
	placingView.Position = ZERO_POINT:Lerp(PLACING_VIEW_HIDE_POSITION, alpha)
end, 0.25)

local actionBox = Create "SelectionBox" {
	Parent = playerGui;
	LineThickness = 0.075;
	Visible = false;
}

local bindableHotkeyPressed = Load "Hotkeys.Interactions.HotkeyPressed"
local bindableIsHotkeyDown = Load "Hotkeys.Interactions.IsHotkeyDown"

----------------------------------------
----- Variables ------------------------
----------------------------------------
local colorPool = {
	Colors.Teal,
	Colors.Green,
	Colors.Orange,
	Colors.OrangeYellow,
	Colors.Pink,
	Colors.Purple,
	Colors.Violet,
}

local colorPoolUSE = {
	Colors.RareERR,
	Colors.Rare1C,
	Colors.Rare2C,
	Colors.Rare3C,
	Colors.Rare4C,
	Colors.Rare5C,
}

local buttons = {}
local quantities = setmetatable({}, {__index = function() return 0 end})
local placing = false
local placingItem = nil
local placingPreview = nil
local placementAction = nil
local lastInventoryChange = tick()
local removingArmor = false

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function GridRound(point)
	return Vector3.new(math.floor(point.X / 0.5 + 0.5) * 0.5, point.Y, math.floor(point.Z / 0.5 + 0.5) * 0.5)
end

local function RemoveArmor()
	if removingArmor then return end
	
	local armors = SharedInventory.GetEquippedArmors(localPlayer)
	
	if #armors > 0 then
		local speed = humanoid.WalkSpeed
		humanoid.WalkSpeed = 0
		removingArmor = true
		removeArmorButton:FindFirstChild("ButtonText").Text = "Removing..."
		remoteRemoveArmor:InvokeServer()
		removeArmorButton:FindFirstChild("ButtonText").Text = "Remove Armor"
		humanoid.WalkSpeed = speed
		removingArmor = false
	end
end

local function ReflowList()
	local x, y = 0, 0
	
	local children = itemList:GetChildren()
	table.sort(children, function(a, b)
		return a.Name < b.Name
	end)
	
	for _, child in ipairs(children) do
		if child.Name:lower():match(searchBox.Text:lower()) and buttons[child.Name] ~= nil and quantities[child.Name] > 0 then
			child.Visible = true
			child.Position = UDim4.FromUDim2(UDim2.new(x, 0, 0, y))
			x = x + 0.25
			if x > 0.75 then
				x = 0
				y = y + ITEM_ENTRY_HEIGHT + ITEM_ENTRY_PADDING
			end
		else
			child.Visible = false
		end
	end
	
	itemList.CanvasSize = UDim2.new(0, 0, 0, y)
end

local function QueueReflow()
	local current = tick()
	lastInventoryChange = current
	
	wait(0.025)
	
	if lastInventoryChange == current then
		ReflowList()
	end
end


local function GetColor(name)
	local actOBJ = game.ReplicatedStorage.Items:FindFirstChild(name)
	local val = 1
	
	if actOBJ ~= nil and DataAccessor.Get(actOBJ, "RARITY") ~= nil then
	local c = DataAccessor.Get(actOBJ, "RARITY")
		if c == "A" then
			val = 6
		elseif c == "B" then
			val = 5
		elseif c == "C" then
			val = 4
		elseif c == "D" then
			val = 3
		elseif c == "E" then
			val = 2
		end
	end
	
	return colorPoolUSE[val]
end


local function StartPlacing(name, suppressUIChange)
	if placing then return end

	local item = playerInventory:FindFirstChild(name)
	
	if item == nil then
		return
	end
	
	placing = true
	placingItem = item
	placingPreview = item:Clone()
	placingPreview.CanCollide = false
	placingPreview.Anchored = true
	placingPreview.Transparency = math.min(0.75, placingItem.Transparency + 0.5)
	actionBox.Visible = true
	
	local action = SharedInventory.GetPlacementAction(item)
	placementAction = action
	
	local hint = DEFAULT_ACTION_HINT
	if action then
		hint = action.GetHint(localPlayer, item)
	end
	
	placementHint.Text = hint
	
	if not suppressUIChange then
		stopPlacingRunner:Stop()
		startPlacingRunner:Restart()
	end
end

local function StopPlacing(suppressUIChange)
	if not placing then return end
	
	placing = false
	placingItem = nil
	placingPreview:Destroy()
	placementAction = nil
	actionBox.Visible = false
	
	if not suppressUIChange then
		startPlacingRunner:Stop()
		stopPlacingRunner:Restart()
	end
end

local function Place(item, part, pointOnPart, suppressPlacementAction)
	if SharedInventory.CanPlaceAt(localPlayer, item, pointOnPart) then
		local placementAction = SharedInventory.GetPlacementAction(item)
		
		-- Get it out of the inventory.
		if RunService:IsClient() and not RunService:IsServer() then
			item.Parent = nil
		end
		
		if not suppressPlacementAction and placementAction ~= nil and placementAction.UsableOn(localPlayer, item, part) then
			remoteActionOn:FireServer(item, part, pointOnPart)
		else
			remotePlaceAt:FireServer(item, pointOnPart)
		end
	end
end

local function GetButton(name)
	if buttons[name] then
		return buttons[name]
	else
		local button = Scaffold(entryScaffold, { ItemName = name })
		button.Parent = itemList
		button.BackgroundColor3 = GetColor(name)
		
		button.InputEnded:connect(function(input)
			local action = input.UserInputType
		
			if action == Enum.UserInputType.MouseButton1 or action == Enum.UserInputType.Touch then
				StartPlacing(name)
			end
		end)
		
		buttons[name] = button
		return button
	end
end

local function InventoryChange(direction)
	return function(item, skipReflow)
		local name = item.Name
		local quantity = quantities[name] + direction
		quantities[name] = quantity
		local button = GetButton(name)
		local needsReflow = false
		
		if quantity > 0 then
			local text = name
		
			if quantity > 1 then
				text = quantity.."x "..text
			else
				needsReflow = true
			end
			
			button:FindFirstChild("ButtonText").Text = text
		else
			button:Destroy()
			buttons[name] = nil
			needsReflow = true
		end
		
		if not skipReflow and needsReflow then
			QueueReflow()
		end
	end
end

local OnItemAdded = InventoryChange(1)
local OnItemRemoved = InventoryChange(-1)
local hotkeyConnection = nil

local function OnEquipped(mouse)
	inventoryGui.Visible = true
	
	mouse.Move:connect(function()
		mouse.TargetFilter = placingPreview
		
		if placing then
			local target = mouse.Target
			local point = mouse.Hit.p
			
			if target ~= nil and SharedInventory.CanPlaceAt(localPlayer, placingItem, point) then
				local usableOn = placementAction ~= nil and placementAction.UsableOn(localPlayer, placingItem, target)
				
				if not usableOn then
					placingPreview.Parent = workspace.CurrentCamera
					placingPreview.CanCollide = true
					placingPreview.Position = GridRound(point)+placingPreview.Size*Vector3.new(0,1/2,0)
					placingPreview.CanCollide = false
					actionBox.Adornee = nil
				else
					placingPreview.Parent = nil
					actionBox.Adornee = target
				end
			else
				placingPreview.Parent = nil
				actionBox.Adornee = nil
			end
		end
	end)
	
	mouse.Button1Down:connect(function()
		mouse.TargetFilter = placingPreview
		
		if placing then
			local target = mouse.Target
			local point = GridRound(mouse.Hit.p)
			
			if target ~= nil and SharedInventory.CanPlaceAt(localPlayer, placingItem, point) then
				local itemName = placingItem.Name
				Place(placingItem, target, point, false)
				
				if bindableIsHotkeyDown:Invoke(CONTINUE_PLACING_HOTKEY_NAME) then
					local item = playerInventory:FindFirstChild(itemName)
					
					if item ~= nil then
						StopPlacing(true)
						StartPlacing(itemName, true)
					else
						StopPlacing(false)
					end
				else
					StopPlacing(false)
				end
			end
		end
	end)
	
	hotkeyConnection = bindableHotkeyPressed.Event:connect(function(hotkey)
		if hotkey == PLACE_ALL_HOTKEY_NAME then
			if placing then
				local itemName = placingItem.Name
				Place(placingItem, mouse.Target, GridRound(mouse.Hit.p), true)
				local children = playerInventory:GetChildren()
				
				for _, child in ipairs(children) do
					if child.Name == itemName and child ~= placingItem then
						if not tool:IsDescendantOf(workspace) then
							break
						end
						
						Place(child, mouse.Target, GridRound(mouse.Hit.p), true)
						wait(0.2)
					end
				end
				
				StopPlacing()
			end
		elseif hotkey == "SelectSearch" then
			wait(0)
			searchBox:CaptureFocus()
		end
	end)
end

local function OnUnequipped()
	inventoryGui.Visible = false
	StopPlacing()
	hotkeyConnection:disconnect()
end

function onDeath()
	inventoryGui:Destroy()
end

----------------------------------------
----- Client Inventory -----------------
----------------------------------------
local gui = Instance.new("ScreenGui", playerGui)
inventoryGui.Parent = gui

searchBox.FocusLost:connect(function(enterPressed)
	if enterPressed then
		ReflowList()
	end
end)

searchButton.InputEnded:connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		ReflowList()
	end
end)

cancelButton.InputEnded:connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		StopPlacing()
	end
end)

removeArmorButton.InputEnded:connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		RemoveArmor()
	end
end)

local startTime = tick()
for _, item in ipairs(playerInventory:GetChildren()) do
	OnItemAdded(item, true)
end
local endTime = tick()
print("[ClientInventory] ~ Populated initial inventory in "..(endTime - startTime).."s")

ReflowList()

playerInventory.ChildAdded:connect(OnItemAdded)
playerInventory.ChildRemoved:connect(OnItemRemoved)

tool.Equipped:connect(OnEquipped)
tool.Unequipped:connect(OnUnequipped)

RunService.RenderStepped:connect(function()
	actionBox.Color3 = Color3.fromHSV(tick() % 1, 1, 1)
end)

while true do
	local character = localPlayer.Character
	if character ~= nil and character:IsDescendantOf(workspace) then
		break
	else
		wait(0)
	end
end

localPlayer.Changed:connect(function(property)
	if property == "Character" then
		gui:Destroy()
	end
end)

humanoid.Died:connect(onDeath)