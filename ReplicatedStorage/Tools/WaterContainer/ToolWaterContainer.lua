----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local Tool = Load "Tools.Tool"
local SharedWaterContainer = Load "Tools.WaterContainer.SharedWaterContainer"
local Scaffold = Load "UI.Scaffolder"
local WaterAmountScaffold = Load "Tools.WaterContainer.WaterAmountScaffold"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local localPlayer = game.Players.LocalPlayer

local remoteFillAttempt = Load "Tools.WaterContainer.FillAttempt"
local remoteWetAttempt = Load "Tools.WaterContainer.WetAttempt"
local remoteDrinkAttempt = Load "Tools.WaterContainer.DrinkAttempt"

----------------------------------------
----- Water Container Tool -------------
----------------------------------------
local ToolWaterContainer = {}
ToolWaterContainer.__index = ToolWaterContainer
setmetatable(ToolWaterContainer, Tool)

function ToolWaterContainer.new(tool)
	local self = setmetatable(Tool.new(tool), ToolWaterContainer)
	
	self.WaterAmount = Scaffold(WaterAmountScaffold)
	self.WaterAmount.Parent = self.Gui
	self.WaterAmount.Visible = false
	
	self.WaterBar = self.WaterAmount:FindFirstChild("AmountBar")
	self.WaterText = self.WaterAmount:FindFirstChild("AmountText")
	self.DrinkButton = self.WaterAmount:FindFirstChild("DrinkButton")
	
	self.DrinkButton.InputBegan:connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			if DataAccessor.Get(self.Object, "Tool.StoredAmount") > 0 then
				remoteDrinkAttempt:FireServer(self.Object)
			end
		end
	end)
	
	return self
end

function ToolWaterContainer:UpdateAmount()
	local amount = DataAccessor.Get(self.Object, "Tool.StoredAmount")
	local maxAmount = DataAccessor.Get(self.Object, "Tool.MaximumAmount")
	
	local percent = amount / maxAmount
	
	self.WaterText.Text = amount.."/"..maxAmount.." portions remaining"
	self.WaterBar.Percent = percent
end

function ToolWaterContainer:OnEquipped()
	local storing = DataAccessor.GetStoringObject(self.Object, "Tool.StoredAmount")
	
	self.StoringConnection = storing.Changed:connect(function()
		self:UpdateAmount()
	end)
	
	self:UpdateAmount()
	
	self.WaterAmount.Visible = true
end

function ToolWaterContainer:OnUnequipped()
	self.StoringConnection:disconnect()
	self.WaterAmount.Visible = false
end

function ToolWaterContainer:OnActivated(mouse)
	local target = mouse.Target
	local point = mouse.Hit.p
	
	if SharedWaterContainer.CanFill(localPlayer, self.Object, target, point) then
		remoteFillAttempt:FireServer(self.Object, target, point)
		return true
	elseif SharedWaterContainer.CanWet(localPlayer, self.Object, target, point) then
		remoteWetAttempt:FireServer(self.Object, target, point)
		return true
	end
	
	return false
end

function ToolWaterContainer:IsInteractable(part, point)
	if SharedWaterContainer.CanFill(localPlayer, self.Object, part, point) then
		return true
	elseif SharedWaterContainer.CanWet(localPlayer, self.Object, part, point) then
		return true
	end
	
	return false
end

return ToolWaterContainer