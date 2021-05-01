----------------------------------------
----- Constants ------------------------
----------------------------------------
local VIEW_HEIGHT = 30
local VIEW_PADDING = 5

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local HotkeyDefinitions = Load "Hotkeys.HotkeyDefinitions"
local Scaffold = Load "UI.Scaffolder"
local Colors = Load "UI.Colors"
local UDim4 = Load "UI.UDim4"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local UserInputService = game:GetService("UserInputService")

local localPlayer = game.Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local hotkeysGui = Instance.new("ScreenGui", playerGui)
hotkeysGui.Name = "HotkeysGui"
local hotkeysContainer = Scaffold(require(script:WaitForChild("GuiScaffold")))
hotkeysContainer.Parent = hotkeysGui
local viewList = hotkeysContainer:FindOnPath("EntryContainer.EntryList")

local toggleButton = Scaffold({
	Scaffold = "TextButton";
	Name = "HotkeysToggle";
	Parent = hotkeysGui;
	BackgroundColor3 = Colors.Blue;
	Text = "Hotkeys";
	Position = UDim4.new(0.4, 5, 0, 10);
	Size = UDim4.new(0.1, 0, 0.025, 0);
})

local bindableRebindHotkey = Load "Hotkeys.Interactions.RebindHotkey"
local bindableResetHotkey = Load "Hotkeys.Interactions.ResetHotkey"
local bindableGetHotkeys = Load "Hotkeys.Interactions.GetHotkeys"
local bindableHotkeyRebound = Load "Hotkeys.Interactions.HotkeyRebound"

----------------------------------------
----- Variables ------------------------
----------------------------------------
local categoryLabels = {}
local hotkeyArrays = {}
local hotkeyViews = {}
local selectedHotkey = nil

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function GetCategoryLabel(name)
	if categoryLabels[name] == nil then
		local label = Scaffold({
			Type = "TextView";
			Name = name;
			BackgroundTransparency = 1;
			Size = UDim4.new(1, 0, 0, VIEW_HEIGHT);
			Text = "  "..name;
			TextColor3 = Colors.White;
			TextXAlignment = Enum.TextXAlignment.Left;
			MaximumFontSize = Enum.FontSize.Size28;
			MinimumFontSize = Enum.FontSize.Size12;
		})
		
		categoryLabels[name] = label
	end
	
	return categoryLabels[name]
end

local function GetHotkeyView(id)
	if hotkeyViews[id] == nil then
		local info = HotkeyDefinitions[id]
		local view = Scaffold({
			Type = "Frame";
			Name = id;
			BackgroundTransparency = 1;
			Size = UDim4.new(1, 0, 0, VIEW_HEIGHT);
			
			{
				Type = "TextView";
				Name = "HotkeyName";
				BackgroundTransparency = 1;
				Position = UDim4.new(0.05, 0, 0.1, 0);
				Size = UDim4.new(0.5, 0, 0.8, 0);
				MaximumFontSize = Enum.FontSize.Size18;
				MinimumFontSize = Enum.FontSize.Size10;
				Text = info.Name;
				TextColor3 = Colors.White;
				TextXAlignment = Enum.TextXAlignment.Left;
			};
			
			{
				Scaffold = "TextButton";
				Name = "ReassignButton";
				BackgroundColor3 = Colors.Blue;
				Position = UDim4.new(0.65, 0, 0, 0);
				Size = UDim4.new(0.25, 0, 1, 0);
				Text = "";
			};
		})
		
		hotkeyViews[id] = view
	end
	
	return hotkeyViews[id]
end

local function StartRebinding(id)
	selectedHotkey = id
	local view = GetHotkeyView(id)
	local viewText = view:FindFirstChild("ReassignButton"):FindFirstChild("ButtonText")
	viewText.Text = "..."
	
	while true do
		if selectedHotkey ~= id then
			break
		end
		
		local input, gameProcessed = UserInputService.InputBegan:wait()
		if input.UserInputType == Enum.UserInputType.Keyboard and not gameProcessed then
			bindableRebindHotkey:Invoke(id, input.KeyCode)
			break
		end
	end
end

local function ResetHotkey(id)
	bindableResetHotkey:Invoke(id)
end

local function ToggleGui()
	hotkeysContainer.Visible = not hotkeysContainer.Visible
end

local function OnHotkeyRebound(id, newKey)
	local view = GetHotkeyView(id)
	local viewText = view:FindFirstChild("ReassignButton"):FindFirstChild("ButtonText")
	viewText.Text = newKey.Name
end

----------------------------------------
----- Client Hotkeys Gui ---------------
----------------------------------------
bindableHotkeyRebound.Event:connect(OnHotkeyRebound)

for id, details in pairs(bindableGetHotkeys:Invoke()) do
	local view = GetHotkeyView(id)
	local categoryView = GetCategoryLabel(details.Category)
	categoryView.Parent = viewList
	view.Parent = viewList
	OnHotkeyRebound(id, details.Key or details.Default)
	view:FindFirstChild("ReassignButton").InputEnded:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			StartRebinding(id)
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			ResetHotkey(id)
		end
	end)
end

toggleButton.InputEnded:connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		ToggleGui()
	end
end)

local children = viewList:GetChildren()
viewList.CanvasSize = UDim2.new(0, 0, 0, VIEW_HEIGHT * #children + VIEW_PADDING * #children)

table.sort(children, function(a, b)
	return a.Name < b.Name
end)

for index, child in ipairs(children) do
	child.Position = UDim4.new(0, 0, 0, (index - 1) * VIEW_HEIGHT + (index - 1) * VIEW_PADDING)
end