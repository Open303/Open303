----------------------------------------
----- Constants ------------------------
----------------------------------------
local DEFAULT_TEXT = "Click an item to consume it."
local FOOD_TEXT_FORMAT = "%s, %d portion%s remaining"

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local SharedConsume = Load "StarterTools.Consume.SharedConsume"
local Scaffold = Load "UI.Scaffolder"
local ConsumeGuiScaffold = Load "StarterTools.Consume.ConsumeGuiScaffold"
local PlayerCharacter = Load "Utility.PlayerCharacter"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local localPlayer = game.Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local humanoid = PlayerCharacter.WaitForCurrentHumanoid(localPlayer)

local tool = script.Parent

local consumeGui = Instance.new("ScreenGui")
consumeGui.Name = "ConsumeGui"
local consumeContainer = Scaffold(ConsumeGuiScaffold)
local itemLabel = consumeContainer:FindFirstChild("ConsumeText")

local remoteConsumeAttempt = Load "StarterTools.Consume.ConsumeAttempt"

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function UpdateGui(part, point)
	if part and SharedConsume.IsEdible(part) and SharedConsume.IsInRange(localPlayer, point) then
		local name = DataAccessor.GetFromAncestors(part, "DisplayName") or part.Name
		local portions = DataAccessor.GetFromAncestors(part, "Edible.Portions")
		local suffix = portions == 1 and "" or "s"
		itemLabel.Text = FOOD_TEXT_FORMAT:format(name, portions, suffix)
	else
		itemLabel.Text = DEFAULT_TEXT
	end
end

local function OnMouseDown(part, point)
	if part and SharedConsume.IsEdible(part) and SharedConsume.IsInRange(localPlayer, point) then
		-- In Play Solo, the client and server are merged.
		-- This leads to both SharedConsume.Consume calls having effect on both the client and server
		-- This means that eating something with two portions once will consume both immediately.
		-- This accounts for it, allowing Play Solo to work as expected.
		if game:GetService("RunService"):IsClient() and game:GetService("RunService"):IsServer() then
			remoteConsumeAttempt:InvokeServer(part, point)
		else
			local undo = SharedConsume.Consume(localPlayer, part, point)
			local success = remoteConsumeAttempt:InvokeServer(part, point)
			
			if not success then
				undo()
				warn("Could not consume "..part:GetFullName().." with mouse at "..tostring(point)..": server denied attempt")
			end
		end
	end
end

local function OnEquipped(mouse)
	consumeContainer.Visible = true
	UpdateGui(mouse.Target, mouse.Hit.p)
	
	mouse.Button1Down:connect(function()
		OnMouseDown(mouse.Target, mouse.Hit.p)
		UpdateGui(mouse.Target, mouse.Hit.p)
	end)
	
	mouse.Move:connect(function()
		UpdateGui(mouse.Target, mouse.Hit.p)
	end)
end

local function OnUnequipped()
	consumeContainer.Visible = false
end

----------------------------------------
----- Main Script ----------------------
----------------------------------------
consumeGui.Parent = playerGui
consumeContainer.Parent = consumeGui
consumeContainer.Visible = false

tool.Equipped:connect(OnEquipped)
tool.Unequipped:connect(OnUnequipped)

humanoid.Died:connect(function()
	consumeGui:Destroy()
end)