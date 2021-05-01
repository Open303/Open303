----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local Tool = Load "Tools.Tool"
local SharedCheeseBin = Load "Tools.CheeseBin.SharedCheeseBin"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local localPlayer = game.Players.LocalPlayer

local remoteBinAttempt = Load "Tools.CheeseBin.BinProcessAttempt"

----------------------------------------
----- Oil Filter Tool ------------------
----------------------------------------
local ToolCheseBin = {}
ToolCheseBin.__index = ToolCheseBin
setmetatable(ToolCheseBin, Tool)

function ToolCheseBin.new(tool)
	local self = setmetatable(Tool.new(tool), ToolCheseBin)
	return self
end

function ToolCheseBin:OnActivated(mouse)
	local target = mouse.Target
	local point = mouse.Hit.p
	
	if SharedCheeseBin.CanBin(localPlayer, target, point) then
		remoteBinAttempt:FireServer(target, point)
		return true, DataAccessor.Get(self.Object, "Tool.ProcessTime")
	end
	
	return false
end

function ToolCheseBin:IsInteractable(part, point)
	return SharedCheeseBin.CanBin(localPlayer, part, point)
end

return ToolCheseBin