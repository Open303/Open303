
local version = game.ReplicatedStorage["Current Version"].Value



----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local Create = Load "Create"
local DataAccessor = Load "Data.DataAccessor"
local Scaffold = Load "UI.Scaffolder"
local Colors = Load "UI.Colors"
local UDim4 = Load "UI.UDim4"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local RunService = game:GetService("RunService")

local localPlayer = game.Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local VersionGui = Instance.new("ScreenGui", playerGui)
VersionGui.Name = "VersionGui"
local VersionToggle = Scaffold({
	Scaffold = "TextButton";
	Name = "ToggleButton";
	Parent = VersionGui;
	BorderColor3 = Colors.White;
	BorderSizePixel = 1;
	BackgroundColor3 = Colors.DarkGray;
	Text = "CURRENT VERSION: "..version;
	Position = UDim4.new(0,5,0.94,-5);
	Size = UDim4.new(0.15, 0, 0.06, 0);
})