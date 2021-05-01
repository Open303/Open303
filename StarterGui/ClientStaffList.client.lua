----------------------------------------
----- Constants ------------------------
----------------------------------------
local RankNames = {
	[1] = "Developers",
	[2] = "Jr. Developers",
	[3] = "Administrators",
	[4] = "Moderators"
}

----------------------------------------
----- Modules --------------------------
----------------------------------------
local import = require(game.ReplicatedStorage:WaitForChild("Import"))
local Scaffold = import "~/UI/Scaffolder"
local Colors = import "~/UI/Colors"
local UDim4 = import "~/UI/UDim4"
local RankChecker = import "~/Commands/RankChecker"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local RunService = game:GetService("RunService")

local localPlayer = game.Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local StaffListGui = Instance.new("ScreenGui", playerGui)
StaffListGui.Name = "StaffListGui"
local StaffListToggle = Scaffold({
	Scaffold = "TextButton";
	Name = "ToggleButton";
	Parent = StaffListGui;
	BackgroundColor3 = Colors.Blue;
	Text = "Staff List";
	Position = UDim4.new(0.6, 15, 0, 10);
	Size = UDim4.new(0.1, 0, 0.025, 0);
})

local StaffListContainer = Instance.new("ScrollingFrame") do
	StaffListContainer.BackgroundColor3 = Colors.DarkGray
	StaffListContainer.BorderColor3 = Colors.White
	StaffListContainer.Position = UDim2.new(0.6, 15, 0.05, 0)
	StaffListContainer.Size = UDim2.new(0.1, 0, 0.25, 0)
	StaffListContainer.ScrollBarThickness = 6
	StaffListContainer.Visible = false
	
	local sizeConstraint = Instance.new("UISizeConstraint")
	sizeConstraint.MinSize = Vector2.new(100, 100)
	sizeConstraint.MaxSize = Vector2.new(math.huge, 400)
	
	local arConstraint = Instance.new("UIAspectRatioConstraint")
	arConstraint.AspectRatio = 3
	arConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
	arConstraint.DominantAxis = Enum.DominantAxis.Width
	
	StaffListContainer.Parent = StaffListGui
end

----------------------------------------
----- Variables ------------------------
----------------------------------------                                  
local guiOpen = false

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function ToggleGui()
	guiOpen = not guiOpen
	StaffListContainer.Visible = guiOpen
end

local function BuildGui()
	local staff = RankChecker.GetStaff()
	
	local y = 0
	for staffRank, staffList in ipairs(staff) do
		if #staffList > 0 then
			local rankName = RankNames[staffRank]
			local rankTitle = Instance.new("TextLabel")
			rankTitle.Name = rankName
			rankTitle.BackgroundTransparency = 1
			rankTitle.Position = UDim2.new(0, 0, 0, y)
			rankTitle.Size = UDim2.new(1, 0, 0, 20)
			rankTitle.Font = Enum.Font.SourceSansBold
			rankTitle.Text = rankName
			rankTitle.TextColor3 = Colors.White
			rankTitle.TextSize = 18
			rankTitle.Parent = StaffListContainer
			
			y = y + 20
			
			for _, id in ipairs(staffList) do
				local name = game:GetService("Players"):GetNameFromUserIdAsync(id)
				local nameEntry = rankTitle:Clone()
				nameEntry.Name = name
				nameEntry.Position = UDim2.new(0, 0, 0, y)
				nameEntry.Font = Enum.Font.SourceSans
				nameEntry.Text = name
				nameEntry.TextSize = 16
				nameEntry.Parent = StaffListContainer
				
				y = y + 20
			end
			
			y = y + 8
		end
	end
	
	StaffListContainer.CanvasSize = UDim2.new(0, 0, 0, y)
end

----------------------------------------
----- Staff List Menu ------------------
----------------------------------------
StaffListToggle.InputEnded:connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		ToggleGui()
	end
end)

StaffListContainer.Visible = false

BuildGui()
