----------------------------------------
----- Objects --------------------------
----------------------------------------
local StarterGui = game:GetService("StarterGui")

local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

----------------------------------------
----- GUI Initialization ---------------
----------------------------------------
StarterGui.ResetPlayerGuiOnSpawn = false
playerGui:SetTopbarTransparency(0)