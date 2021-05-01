----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local ToolMeleeWeapon = Load "Tools.MeleeWeapon.ToolMeleeWeapon"
local SharedHarvesting = Load "Tools.Harvesting.SharedHarvesting"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local localPlayer = game.Players.LocalPlayer

local remoteHarvestAttempt = Load "Tools.Harvesting.HarvestAttempt"

----------------------------------------
----- Knife Tool -----------------------
----------------------------------------
local ToolHarvesting = {}
ToolHarvesting.__index = ToolHarvesting
setmetatable(ToolHarvesting, ToolMeleeWeapon)

function ToolHarvesting.new(tool)
	local self = setmetatable(ToolMeleeWeapon.new(tool), ToolHarvesting)
	return self
end

function ToolHarvesting:OnActivated(mouse)
	local target = mouse.Target
	local point = mouse.Hit.p
	
	if SharedHarvesting.CanHarvest(localPlayer, self.Object, target, point) then
		remoteHarvestAttempt:FireServer(self.Object, target, point)
		return true
	end
	
	return ToolMeleeWeapon.OnActivated(self, mouse)
end

function ToolHarvesting:IsInteractable(part, point)
	return SharedHarvesting.CanHarvest(localPlayer, self.Object, part, point)
end

return ToolHarvesting