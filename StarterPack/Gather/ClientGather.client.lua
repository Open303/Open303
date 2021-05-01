----------------------------------------
----- Constants ------------------------
----------------------------------------
local DEFAULT_TEXT = "Click an object to gather it."

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local SharedGather = Load "StarterTools.Gather.SharedGather"
local UDim4 = Load "UI.UDim4"
local Scaffold = Load "UI.Scaffolder"
local FunctionRunner = Load "Animation.FunctionRunner"
local PlayerCharacter = Load "Utility.PlayerCharacter"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local RunService = game:GetService("RunService")

local localPlayer = game.Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local humanoid = PlayerCharacter.WaitForCurrentHumanoid(localPlayer)
local tool = script.Parent

local gatherGuiScaffold = Load "StarterTools.Gather.GatherGuiScaffold"
local gatherContainer = Scaffold(gatherGuiScaffold)
local textView = gatherContainer:FindFirstChild("GatherText")
local progressBar = gatherContainer:FindFirstChild("GatherProgress")

local remoteGatherAttempt = Load "StarterTools.Gather.GatherAttempt"
local remoteGatherAbort = Load "StarterTools.Gather.GatherAbort"

----------------------------------------
----- Variables ------------------------
----------------------------------------
local gathering = false
local gatherTarget = nil
local lastGatherStart = nil
local gatherTime = 0
local lastSpeed = 0
local currentMouse

local runner = FunctionRunner.new(function(alpha)
	progressBar.Percent = alpha
end, 1)

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function UpdateText(target, point)
	local text
	
	if gathering then
		text = "Gathering "..gatherTarget.Name
	elseif target ~= nil and point ~= nil and SharedGather.CanGather(localPlayer, target, point) then
		text = SharedGather.GetGatherResult(target).Name
	else
		text = DEFAULT_TEXT
	end
	
	textView.Text = text
end

local function StopGathering(aborted)
	if not gathering then return end
	
	if aborted then
		remoteGatherAbort:FireServer()
	end
	
	gathering = false
	gatherTarget = nil
	runner:Stop()
	progressBar.Percent = 0
	humanoid.WalkSpeed = lastSpeed
end

local function StartGathering(part, pointOnPart)
	if gathering then return end
	if not SharedGather.CanGather(localPlayer, part, pointOnPart) then return end
	
	local result = SharedGather.GetGatherResult(part)
	
	local gatherStart = tick()
	local currentGatherTime = SharedGather.GetGatherTime(localPlayer, result)
	
	gathering = true
	gatherTarget = result
	lastGatherStart = gatherStart
	lastSpeed = humanoid.WalkSpeed
	gatherTime = currentGatherTime
	
	humanoid.WalkSpeed = 0
	progressBar.Percent = 0
	runner:Stop()
	runner.Duration = currentGatherTime
	runner:RunAsync()
	
	local success = remoteGatherAttempt:InvokeServer(part, pointOnPart)
	if not success then
		warn("Server rejected gathering of "..part.Name.." (point on part: "..tostring(pointOnPart)..")")
	end
	
	if lastGatherStart == gatherStart then
		StopGathering()
	end
end

local function OnEquipped(mouse)
	currentMouse = mouse
	gatherContainer.Visible = true
	
	mouse.Button1Down:connect(function()
		if gathering then return end
		StartGathering(mouse.Target, mouse.Hit.p)
	end)
end

local function OnUnequipped()
	currentMouse = nil
	gatherContainer.Visible = false
	StopGathering(true)
end

----------------------------------------
----- Client Gather --------------------
----------------------------------------
tool.Equipped:connect(OnEquipped)
tool.Unequipped:connect(OnUnequipped)

local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "GatherGui"
gatherContainer.Parent = gui
gatherContainer.Visible = false

lastSpeed = humanoid.WalkSpeed

RunService.Stepped:connect(function()
	if currentMouse ~= nil then
		UpdateText(currentMouse.Target, currentMouse.Hit.p)
	end
end)

humanoid.Died:connect(function()
	gui:Destroy()
	StopGathering(true)
end)