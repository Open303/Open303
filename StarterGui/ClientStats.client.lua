----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local StatDefinitions = Load "Stats.Definitions"
local SharedStats = Load "Stats.SharedStats"
local Scaffold = Load "UI.Scaffolder"
local StatGuiScaffold = Load "Stats.StatsGuiScaffold"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local StarterGui = game:GetService("StarterGui")

local localPlayer = game.Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

--local statsGui = Load "Stats.StatsGui":Clone()
--local statsContainer = Load("Stats.Container", statsGui)
local statsGui = Instance.new("ScreenGui", playerGui)
statsGui.Name = "StatsGui"

local statsContainer = Scaffold(StatGuiScaffold)
statsContainer.Parent = statsGui

----------------------------------------
----- Variables ------------------------
----------------------------------------
local sentWarnings = {}

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function UpdateBar(barName, newValue)
	local definition = StatDefinitions[barName]
	local view = statsContainer:FindFirstChild(barName)
	
	if not view then return end
	
	local percent = (newValue - definition.MinValue) / (definition.MaxValue - definition.MinValue)
	view:FindFirstChild("StatBar").Percent = percent
	view:FindFirstChild("StatText").Text = barName..": "..(math.floor(percent * 100 + 0.5)).."%"
	
	if percent < 0.1 and not definition.NonCritical then
		if not sentWarnings[barName] then
			StarterGui:SetCore("ChatMakeSystemMessage", {
				Text = "Your "..barName.." is low!";
				Color = Color3.new(1, .3, .3);
			})
			
			sentWarnings[barName] = true
		end
	else
		sentWarnings[barName] = false
	end
end

----------------------------------------
----- Client Stats ---------------------
----------------------------------------
statsGui.Parent = playerGui

for statName, definition in pairs(StatDefinitions) do
	UpdateBar(statName, 100)
	
	local backingStore = SharedStats.GetStatObject(localPlayer, statName)
	UpdateBar(statName, backingStore.Value)
	backingStore.Changed:connect(function(newValue)
		UpdateBar(statName, newValue)
	end)
end