----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local Tool = Load "Tools.Tool"
local SharedFireStarter = Load "Tools.FireStarter.SharedFireStarter"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local localPlayer = game.Players.LocalPlayer

local remoteFireStartAttempt = Load "Tools.FireStarter.FireStartAttempt"

----------------------------------------
----- Fire Starter Tool ----------------
----------------------------------------
local ToolFireStarter = {}
ToolFireStarter.__index = ToolFireStarter
setmetatable(ToolFireStarter, Tool)

function ToolFireStarter.new(tool)
	local self = setmetatable(Tool.new(tool), ToolFireStarter)
	return self
end

function ToolFireStarter:OnActivated(mouse)
	local target = mouse.Target
	local point = mouse.Hit.p
	
	if SharedFireStarter.CanIgnite(localPlayer, target, point) then
		remoteFireStartAttempt:FireServer(target, point)
		return true
	end
	
	return false
end

function ToolFireStarter:IsInteractable(part, pointOnPart)
	return SharedFireStarter.CanIgnite(localPlayer, part, pointOnPart)
end

return ToolFireStarter