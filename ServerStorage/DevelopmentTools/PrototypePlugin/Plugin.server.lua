-- Squelch warning about unknown global
plugin = script.Parent

----------------------------------------
----- Constants ------------------------
----------------------------------------
local TOOLBAR_NAME = "Survival Plugins"
local BUTTON_NAME = "Set Prototype"
local BUTTON_TOOLTIP = "Allows you to set the prototype of objects."
local BUTTON_IMAGE = ""
local BUTTON_SPACING = 5

----------------------------------------
----- Objects --------------------------
----------------------------------------
local CoreGuiService = game:GetService("CoreGui")
local SelectionService = game:GetService("Selection")

local toolbar = plugin:CreateToolbar(TOOLBAR_NAME)
local button = toolbar:CreateButton(BUTTON_NAME, BUTTON_TOOLTIP, BUTTON_IMAGE)

local pluginGui = plugin.PrototypeGui
local prototypeList = pluginGui.PrototypeSetter.SelectionList
local searchBox = pluginGui.PrototypeSetter.SearchContainer.Search
local selectionLabel = pluginGui.PrototypeSetter.Targets
local listEntryTemplate = plugin.ListEntryTemplate

local prototypeBin do
	local object = game.ReplicatedStorage:FindFirstChild("Data")
	
	if not object then
		error("Data container not found - should be located at game.ReplicatedStorage.Data.")
	end
	
	prototypeBin = object:FindFirstChild("Prototypes")
	
	if not prototypeBin then
		error("Prototype container not found - should be located at game.ReplicatedStorage.Data.Prototypes.")
	end
end

----------------------------------------
----- Modules --------------------------
----------------------------------------
local ButtonHelper = require(plugin.ButtonHelper)

----------------------------------------
----- Variables ------------------------
----------------------------------------
local enabled = false
local prototypeButtons = {}
local connections = {}

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function IsPrototype(object)
	return object.Parent == game.ReplicatedStorage.Data.Prototypes
end

local function GetDataContainer(object, shouldCreate)
	if IsPrototype(object) then
		return object
	else
		local container = object:FindFirstChild("Data")
		
		if not container and shouldCreate then
			container = Instance.new("Folder", object)
			container.Name = "Data"
		end
		
		return container
	end
end

local function GetPrototypeObject(object, shouldCreate)
	if object.Name == "Prototype" and object:IsA("ObjectValue") and (object.Parent.Name == "Data" or IsPrototype(object.Parent)) then
		return object
	end

	local container = GetDataContainer(object, shouldCreate)
	
	if not container then
		return nil
	end
	
	local prototypeReference = container:FindFirstChild("Prototype")
	
	if not prototypeReference and shouldCreate then
		prototypeReference = Instance.new("ObjectValue", container)
		prototypeReference.Name = "Prototype"
	end
	
	return prototypeReference
end

local function GetPrototype(object)
	local reference = GetPrototypeObject(object, false)
	
	if reference then
		return reference.Value
	end
end

local function SetPrototype(object, value)
	local reference = GetPrototypeObject(object, true)
	reference.Value = value
end

local function GetAllPrototypes()
	local prototypes = {}
	
	for _, prototype in ipairs(prototypeBin:GetChildren()) do
		table.insert(prototypes, prototype)
	end
	
	return prototypes
end

local function ReflowList()
	local y = 0
	
	for _, button in ipairs(prototypeList:GetChildren()) do
		if button.Visible then
			button.Position = UDim2.new(0, 0, 0, y)
			y = y + button.AbsoluteSize.Y + BUTTON_SPACING
		end
	end
	
	prototypeList.CanvasSize = UDim2.new(0, 0, 0, y)
end

local function FilterList()
	for _, button in ipairs(prototypeList:GetChildren()) do
		if not button.Name:lower():match(searchBox.Text:lower()) then
			button.Visible = false
		else
			button.Visible = true
		end
	end
	
	ReflowList()
end

local function SetEnabled(newEnabled)
	enabled = newEnabled
	button:SetActive(enabled)
	pluginGui.Parent = enabled and CoreGuiService or plugin
end

local function RebuildList()
	prototypeList:ClearAllChildren()
	
	for _, connection in ipairs(connections) do
		connection:disconnect()
	end
	
	local prototypes = GetAllPrototypes()
	
	table.sort(prototypes, function(a, b)
		return a.Name < b.Name
	end)
	
	for index, prototype in ipairs(prototypes) do
		local button = listEntryTemplate:Clone()
		button.Name = prototype.Name
		button.Parent = prototypeList
		button.ButtonText.Text = prototype.Name
		button.Position = UDim2.new(0, 0, 0, (index - 1) * (button.AbsoluteSize.Y + BUTTON_SPACING))
		button.Size = UDim2.new(1, -10, 0, 30)
		
		button.MouseButton1Click:connect(function()
			for _, object in ipairs(SelectionService:Get()) do
				SetPrototype(object, prototype)
				print("[Prototype Plugin] ~ Set prototype of "..object:GetFullName().." to "..prototype:GetFullName())
			end
		end)
		
		ButtonHelper.SetupAutoColor(button)
		
		local connection = prototype.Changed:connect(function(property)
			if property == "Name" then
				button.Name = prototype.Name
				button.ButtonText.Text = prototype.Name
				FilterList()
			end
		end)
		
		table.insert(connections, connection)
	end
	
	FilterList()
end

----------------------------------------
----- Prototype Plugin -----------------
----------------------------------------
RebuildList()

prototypeBin.ChildAdded:connect(RebuildList)
prototypeBin.ChildRemoved:connect(RebuildList)

searchBox.Changed:connect(FilterList)

SelectionService.SelectionChanged:connect(function()
	local items = SelectionService:Get()
	
	if #items == 1 then
		selectionLabel.Text = "Changing prototype of "..items[1]:GetFullName()
	elseif #items > 1 then
		selectionLabel.Text = "Changing prototype of "..#items.." objects."
	else
		selectionLabel.Text = "Select an object to set its prototype."
	end
end)

button.Click:connect(function()
	SetEnabled(not enabled)
end)

plugin.Deactivation:connect(function()
	SetEnabled(false)
end)