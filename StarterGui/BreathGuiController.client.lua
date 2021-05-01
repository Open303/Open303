local DROWN_TIME = 20

local Load = require(game:GetService("ReplicatedStorage"):WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local Colors = Load "UI.Colors"

local localPlayer = game:GetService("Players").LocalPlayer

local breathGui = Instance.new("ScreenGui")
breathGui.Name = "BreathGui"
breathGui.Parent = script.Parent

local frame = Instance.new("Frame")
frame.Name = "BreathFrame"
frame.BackgroundColor3 = Colors.DarkGray
frame.BorderColor3 = Colors.LightGray
frame.Position = UDim2.new(0.5, 0, 0.3, 0)
frame.Size = UDim2.new(0.15, 0, 0.05, 0)
frame.ZIndex = 4
frame.Parent = breathGui

local barBase = frame:Clone()
barBase.Name = "Bar"
barBase.BackgroundColor3 = Colors.Gray
barBase.BorderSizePixel = 0
barBase.Position = UDim2.new(0.05, 0, 0.1, 0)
barBase.Size = UDim2.new(0.9, 0, 0.8, 0)
barBase.Parent = frame

local bar = barBase:Clone()
bar.Name = "Real"
bar.BackgroundColor3 = Colors.Blue
bar.Position = UDim2.new(0, 0, 0, 0)
bar.Size = UDim2.new(1, 0, 1, 0)
bar.Parent = barBase

frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Visible = false

local function UpdateBar()
	local secondsUnderwater = DataAccessor.Get(localPlayer, "Stats.SecondsUnderwater") or 0
	local fraction = 1 - (math.min(secondsUnderwater, DROWN_TIME) / DROWN_TIME)
	bar:TweenSize(UDim2.new(fraction, 0, 1, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quart, 0.15, true)
	frame.Visible = fraction < 1
end

local function OnCharacterAdded(character)
	UpdateBar()
end

local object = DataAccessor.GetStoringObject(localPlayer, "Stats.SecondsUnderwater")
object.Changed:Connect(UpdateBar)
