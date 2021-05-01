----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local Tool = Load "Tools.Tool"
local SharedMilker = Load "Tools.Milker.SharedMilker"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local localPlayer = game.Players.LocalPlayer

local remoteMilkAttempt = Load "Tools.Milker.MilkAttempt"

----------------------------------------
----- Milking Tool ---------------------
----------------------------------------
local ToolMilker = {}
ToolMilker.__index = ToolMilker
setmetatable(ToolMilker, Tool)

function ToolMilker.new(tool)
	local self = setmetatable(Tool.new(tool), ToolMilker)
	return self
end

function ToolMilker:OnActivated(mouse)
	local target = mouse.Target
	local point = mouse.Hit.p
	
	if SharedMilker.CanMilk(localPlayer, target, point) then
		remoteMilkAttempt:FireServer(target, point)
		return true, DataAccessor.Get(self.Object, "Tool.MilkTime")
	end
	
	return false
end

function ToolMilker:IsInteractable(part, point)
	return SharedMilker.CanMilk(localPlayer, part, point)
end

return ToolMilker