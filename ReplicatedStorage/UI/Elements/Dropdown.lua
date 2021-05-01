local ELEMENT_HEIGHT = 25

local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local Element = Load "UI.Elements.Element"
local UDim4 = Load "UI.UDim4"
local ScrollingFrame = Load "UI.Elements.ScrollingFrame"
local Button = Load "UI.Elements.Button"
local TextView = Load "UI.Elements.TextView"
local Signal = Load "Utility.Signal"
local Colors = Load "UI.Colors"

local Dropdown = {}
setmetatable(Dropdown, { __index = Element })
Dropdown.ClassName = "Dropdown"
Dropdown.__index = Element.__index
Dropdown.__newindex = Element.__newindex

function Dropdown.new()
	local root = Button.new()
	local text = TextView.new()
	text.Parent = root
	text.Name = "ButtonText"
	text.BackgroundTransparency = 1
	text.Position = UDim4.new(0.05, 0, 0.1, 0)
	text.Size = UDim4.new(0.9, 0, 0.8, 0)
	text.MaximumFontSize = Enum.FontSize.Size18
	text.MinimumFontSize = Enum.FontSize.Size10
	text.Text = ""
	text.TextColor3 = Colors.White
	
	local list = ScrollingFrame.new()
	list.Parent = root
	list.Name = "EntryList"
	list.BorderSizePixel = 0
	list.Size = UDim4.new(1, 0, 0, 0)
	list.Position = UDim4.new(0, 0, 1, 0)
	list.ScrollBarThickness = 0
	
	local self = setmetatable(Element.new(root.RobloxObject), Dropdown)
	
	self.SelectionButton = root
	self.EntryList = list
	
	self._open = false
	self._optionColor = Color3.new(1, 1, 1)
	self._maxOptionsShown = 5
	self._currentOption = nil
	self._noOptionText = ""
	
	self.SelectionButton.InputBegan:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			self.Open = not self.Open
		end
	end)
	
	return self
end

-- Properties
do
	function Dropdown:get_BackgroundColor3()
		return self.SelectionButton.BackgroundColor3
	end
	
	function Dropdown:set_BackgroundColor3(value)
		self.SelectionButton.BackgroundColor3 = value
	end
	
	function Dropdown:get_OptionColor3()
		return self._optionColor
	end
	
	function Dropdown:set_OptionColor3(value)
		self._optionColor = value
		
		self.EntryList.BackgroundColor3 = value
		
		for _, child in ipairs(self.EntryList:GetChildren()) do
			child.BackgroundColor3 = value
		end
	end
	
	function Dropdown:get_MaxOptionsShown()
		return self._maxOptionsShown
	end
	
	function Dropdown:set_MaxOptionsShown(value)
		self._maxOptionsShown = value
		self:_update()
	end
	
	function Dropdown:get_Open()
		return self._open
	end
	
	function Dropdown:set_Open(value)
		self._open = value
		self.EntryList.ScrollBarThickness = value and 5 or 0
		self:_update()
	end
	
	function Dropdown:get_CurrentOption()
		return self._currentOption
	end
	
	function Dropdown:set_CurrentOption(value)
		local current = self._currentOption
		
		if current ~= nil then
			local button = self.EntryList:FindFirstChild(current)
			button:FindFirstChild("ButtonText").Font = Enum.Font.SourceSans
		end
		
		if value ~= nil then
			local button = self.EntryList:FindFirstChild(value)
			if button == nil then
				self:_makeButtonFor(value)
				button = self.EntryList:FindFirstChild(value)
			end
			
			button:FindFirstChild("ButtonText").Font = Enum.Font.SourceSansBold
			self.SelectionButton:FindFirstChild("ButtonText").Text = value
		else
			self.SelectionButton:FindFirstChild("ButtonText").Text = self.NoOptionText
		end
		
		self._currentOption = value
	end
	
	function Dropdown:get_NoOptionText()
		return self._noOptionText
	end
	
	function Dropdown:set_NoOptionText(value)
		self._noOptionText = value
		
		if self._currentOption == nil then
			self.SelectionButton:FindFirstChild("ButtonText").Text = value
		end
	end
	
	function Dropdown:set_ZIndex(value)
		self.SelectionButton.ZIndex = value
		self.SelectionButton:FindFirstChild("ButtonText").ZIndex = value
		self.EntryList.ZIndex = value
		
		for _, option in ipairs(self.EntryList:GetChildren()) do
			option.ZIndex = value
			option:FindFirstChild("ButtonText").ZIndex = value
		end
	end
end

function Dropdown:_clearOptions()
	for _, button in ipairs(self.EntryList:GetChildren()) do
		button:Destroy()
	end
end

function Dropdown:_update()
	local elements = self.EntryList:GetChildren()
	local elementCount = #elements
	local shownCount = math.min(elementCount, self.MaxOptionsShown)
	local height = 0
	
	if self.Open then
		height = shownCount * ELEMENT_HEIGHT
	end
	
	local y = 0
	for _, element in ipairs(elements) do
		element.Position = UDim4.new(0, 0, 0, y)
		y = y + ELEMENT_HEIGHT
	end
	
	self.EntryList.CanvasSize = UDim2.new(0, 0, 0, elementCount * ELEMENT_HEIGHT)
	self.EntryList.Size = UDim4.new(1, 0, 0, height)
end

function Dropdown:_makeButtonFor(option)
	if self.EntryList:FindFirstChild(option) == nil then
		local button = Button.new()
		button.Name = option
		button.BackgroundColor3 = self.OptionColor3
		button.Size = UDim4.new(1, 0, 0, ELEMENT_HEIGHT)
		button.Parent = self.EntryList
		button.ZIndex = self.ZIndex
		
		local text = TextView.new()
		text.Parent = button
		text.Name = "ButtonText"
		text.BackgroundTransparency = 1
		text.Position = UDim4.new(0.05, 0, 0.1, 0)
		text.Size = UDim4.new(0.9, 0, 0.8, 0)
		text.MaximumFontSize = Enum.FontSize.Size18
		text.MinimumFontSize = Enum.FontSize.Size10
		text.Text = option
		text.TextColor3 = Colors.White
		text.ZIndex = self.ZIndex
		
		button.InputEnded:connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				self.CurrentOption = option
				self.Open = false
			end
		end)
	end
end

function Dropdown:SetOptions(options)
	self:_clearOptions()
	
	local current = self.CurrentOption
	local currentExistsInNew = false
	
	for _, option in ipairs(options) do
		if option ~= nil then
			self:_makeButtonFor(tostring(option))
			
			if tostring(option) == current then
				currentExistsInNew = true
			end
		end
	end
	
	if currentExistsInNew then
		self.CurrentOption = current
	end
	
	self:_update()
end

return Dropdown