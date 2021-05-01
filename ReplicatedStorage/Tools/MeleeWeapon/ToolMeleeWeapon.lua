----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local Tool = Load "Tools.Tool"
local SharedMeleeWeapon = Load "Tools.MeleeWeapon.SharedMeleeWeapon"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local localPlayer = game.Players.LocalPlayer

local remoteAttackAttempt = Load "Tools.MeleeWeapon.AttackAttempt"

----------------------------------------
----- Weapon Tool ----------------------
----------------------------------------
local ToolMeleeWeapon = {}
ToolMeleeWeapon.__index = ToolMeleeWeapon
setmetatable(ToolMeleeWeapon, Tool)

function ToolMeleeWeapon.new(tool)
	local self = setmetatable(Tool.new(tool), ToolMeleeWeapon)
	return self
end

function ToolMeleeWeapon:OnActivated(mouse)
	local target = mouse.Target
	local point = mouse.Hit.p
	
	if SharedMeleeWeapon.CanAttack(localPlayer, self.Object, target, point) then
		remoteAttackAttempt:FireServer(self.Object, target, point)
		
		return true
	end
	
	return true
end

function ToolMeleeWeapon:IsInteractable(part, point)
	return false
end

return ToolMeleeWeapon