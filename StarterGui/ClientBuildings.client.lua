----------------------------------------
----- Constants ------------------------
----------------------------------------
local BUILDING_DESTROYED_MESSAGE = "Building destroyed!"
local BUILDING_ENTRY_HEIGHT = 30
local BUILDING_ENTRY_WIDTH = 0.25
local BUILDING_ENTRY_PADDING = 5

local RETOOL_HOTKEY_NAME = "BuildingsRetoolSelected"
local DELETE_HOTKEY_NAME = "BuildingsDeleteSelected"
local TRANSFER_HOTKEY_NAME = "BuildingsTransferSelected"
local TOGGLE_GUI_HOTKEY_NAME = "BuildingsToggleGui"

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local Create = Load "Create"
local DataAccessor = Load "Data.DataAccessor"
local SharedBuildings = Load "BuildingsMenu.SharedBuildings"
local Scaffold = Load "UI.Scaffolder"
local Colors = Load "UI.Colors"
local UDim4 = Load "UI.UDim4"
local BuildingsGuiScaffold = Load "BuildingsMenu.BuildingsGuiScaffold"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local RunService = game:GetService("RunService")

local localPlayer = game.Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local buildingsGui = Instance.new("ScreenGui", playerGui)
buildingsGui.Name = "BuildingsGui"
local buildingsToggle = Scaffold({
	Scaffold = "TextButton";
	Name = "ToggleButton";
	Parent = buildingsGui;
	BackgroundColor3 = Colors.Blue;
	Text = "Buildings";
	Position = UDim4.new(0.3, 0, 0, 10);
	Size = UDim4.new(0.1, 0, 0.025, 0);
})

local buildingsContainer = Scaffold(BuildingsGuiScaffold)
buildingsContainer.Parent = buildingsGui
local entryList = buildingsContainer:FindOnPath("BuildingsListBackground.BuildingsList")
local searchBox = buildingsContainer:FindOnPath("Top.Search.SearchBox")
local searchButton = buildingsContainer:FindOnPath("Top.Search.SearchButton")
local deleteButton = buildingsContainer:FindOnPath("Top.DeleteButton")
local retoolButton = buildingsContainer:FindOnPath("Top.RetoolButton")
local transferButton = buildingsContainer:FindOnPath("Top.TransferButton")
local playerSelection = buildingsContainer:FindOnPath("Top.PlayerSelection")

local remoteDeleteAttempt = Load "BuildingsMenu.DeleteAttempt"
local remoteRetoolAttempt = Load "BuildingsMenu.RetoolAttempt"
local remoteTransferAttempt = Load "BuildingsMenu.TransferAttempt"
local bindableHotkeyPressed = Load "Hotkeys.Interactions.HotkeyPressed"

----------------------------------------
----- Variables ------------------------
----------------------------------------
local buildingButtons = {}
local buildingOwnerConnections = {}
local guiOpen = false
local currentBuilding = nil

local box = Create "SelectionBox" {
	Name = "BuildingsMenuSelectionBox";
	Parent = playerGui;
}

local colorPool = {
	Colors.Teal,
	Colors.Green,
	Colors.Orange,
	Colors.OrangeYellow,
	Colors.Pink,
	Colors.Purple,
	Colors.Violet,
}

local hasOpened = false

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function ToggleGui()
	guiOpen = not guiOpen
	buildingsContainer.Visible = guiOpen
end

local function GetColor(name)
	local value = 0
	
	for i = 1, name:len() do
		local char = name:sub(i, i)
		local byte = char:byte()
		value = value + byte
	end
	
	return colorPool[(value % #colorPool) + 1]
end

local function SelectBuilding(building)
	if currentBuilding ~= nil then
		local currentButton = buildingButtons[currentBuilding]
		currentButton:FindFirstChild("ButtonText").Font = Enum.Font.SourceSans
	end
	
	if building ~= nil then
		local button = buildingButtons[building]
		button:FindFirstChild("ButtonText").Font = Enum.Font.SourceSansBold
	end
	
	currentBuilding = building
	box.Adornee = building
end

function ReflowList()
	local entries = entryList:GetChildren()
	
	table.sort(entries, function(a, b)
		return a.Name < b.Name
	end)
	
	local x, y = 0, 0
	
	for _, entry in ipairs(entries) do
		if entry.Name:lower():match(searchBox.Text:lower()) then
			entry.Visible = true
			entry.Position = UDim4.new(x, 0, 0, y)
			x = x + BUILDING_ENTRY_WIDTH
			
			if x >= 1 then
				x = 0
				y = y + BUILDING_ENTRY_HEIGHT + BUILDING_ENTRY_PADDING
			end
		else
			entry.Visible = false
		end
	end
	
	entryList.CanvasSize = UDim2.new(0, 0, 0, math.ceil(#entries / 3) * 40)
end

function CreateBuildingButton(building)
	if buildingButtons[building] ~= nil then
		return buildingButtons[building]
	end
	
	local button = Scaffold({
		Scaffold = "TextButton";
		Name = building.Name;
		Parent = entryList;
		BackgroundColor3 = GetColor(building.Name);
		Text = building.Name;
		Size = UDim4.new(BUILDING_ENTRY_WIDTH, -BUILDING_ENTRY_PADDING, 0, BUILDING_ENTRY_HEIGHT);
	})
	
	buildingButtons[building] = button
	
	button.InputEnded:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if currentBuilding == building then
				SelectBuilding(nil)
			else
				SelectBuilding(building)
			end
		end
	end)
	
	ReflowList()
end

local function RemoveBuildingButton(building)
	if buildingButtons[building] == nil then
		return
	end
	
	SelectBuilding(nil)
	local button = buildingButtons[building]
	button:Destroy()
	ReflowList()
	
	buildingButtons[building] = nil
end

local function OnConstructableAdded(constructable)
	local storing = DataAccessor.GetStoringObject(constructable, "Owner")
	if SharedBuildings.IsBuilding(constructable) then
		storing.Changed:connect(function()
			if DataAccessor.Get(constructable, "Owner") == localPlayer then
				CreateBuildingButton(constructable)
			else
				RemoveBuildingButton(constructable)
			end
		end)
	
		if DataAccessor.Get(constructable, "Owner") == localPlayer then
			CreateBuildingButton(constructable)
		end
	end
end

local function OnConstructableRemoved(constructable)
	if buildingButtons[constructable] ~= nil then
		RemoveBuildingButton(constructable)
	end
end

local function UpdateDropdown()
	local players = game.Players:GetPlayers()
	
	for i = #players, 1, -1 do
		if players[i] == localPlayer then
			table.remove(players, i)
		else
			players[i] = players[i].Name
		end
	end
	
	playerSelection:SetOptions(players)
end

local function MakeActionButton(button, remoteEvent, mustBeIntact)
	local lastPress = nil
	local text = button:FindFirstChild("ButtonText")
	local originalText = text.Text
		
	return function(input)
		if currentBuilding == nil then return end
		
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if mustBeIntact and SharedBuildings.IsDestroyed(currentBuilding) then
				local press = tick()
				lastPress = press
				text.Text = BUILDING_DESTROYED_MESSAGE
				wait(2)
				
				if lastPress == press then
					text.Text = originalText
				end
			else
				remoteEvent:FireServer(currentBuilding, game.Players:FindFirstChild(playerSelection.CurrentOption or ""))
				
			end
		end
	end
end

----------------------------------------
----- Buildings Menu -------------------
----------------------------------------
buildingsToggle.InputEnded:connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		ToggleGui()
	end
end)

buildingsContainer.Visible = false


local buildingscount = game.Workspace.Constructables:GetChildren()

if #buildingscount > 0 then
	for _, buildingold in ipairs(workspace.Constructables:GetChildren()) do
		local xyz = DataAccessor.Get(buildingold, "OwnerString")
		if xyz == localPlayer.Name then
			local abc = DataAccessor.Get(buildingold, "Prototype")
			if abc.Name == "Constructable" or abc.Name == "ConstructableWater" then
				if abc.Name ~= "Vehicle" then
					CreateBuildingButton(buildingold)
				end
			end
		end
	end
end
ReflowList()

--Note: This was commented out in the original o303 version.
--I've not found any reason why, so I've re-enabled it. This code refills the player's menu with their buildings when they rejoin.
for _, ownedBuilding in ipairs(SharedBuildings.GetOwnedBuildings(localPlayer)) do
	OnConstructableAdded(ownedBuilding)
end
ReflowList()

UpdateDropdown()

game.Players.ChildAdded:connect(UpdateDropdown)
game.Players.ChildRemoved:connect(UpdateDropdown)

SharedBuildings.ConstructableAdded:connect(OnConstructableAdded)
SharedBuildings.ConstructableRemoved:connect(OnConstructableRemoved)

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

local retoolCallback = MakeActionButton(retoolButton, remoteRetoolAttempt, true)
local deleteCallback = MakeActionButton(deleteButton, remoteDeleteAttempt, false)
local transferCallback = MakeActionButton(transferButton, remoteTransferAttempt, true)

retoolButton.InputEnded:connect(retoolCallback)
deleteButton.InputEnded:connect(deleteCallback)
transferButton.InputEnded:connect(transferCallback)

bindableHotkeyPressed.Event:connect(function(hotkey)
	if hotkey == RETOOL_HOTKEY_NAME then
		retoolCallback({ UserInputType = Enum.UserInputType.MouseButton1 })
	elseif hotkey == DELETE_HOTKEY_NAME then
		deleteCallback({ UserInputType = Enum.UserInputType.MouseButton1 })
	elseif hotkey == TRANSFER_HOTKEY_NAME then
		transferCallback({ UserInputType = Enum.UserInputType.MouseButton1 })
	elseif hotkey == TOGGLE_GUI_HOTKEY_NAME then
		ToggleGui()
	elseif hotkey == "SelectSearch" and guiOpen then
		wait(0)
		searchBox:CaptureFocus()
	end
end)

RunService.RenderStepped:connect(function()
	box.Color3 = Color3.fromHSV(tick() % 1, 1, 1)
end)