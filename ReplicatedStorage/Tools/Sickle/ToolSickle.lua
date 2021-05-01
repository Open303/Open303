----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local Tool = Load "Tools.Tool"
--local ToolMeleeWeapon = Load "Tools.MeleeWeapon.ToolMeleeWeapon"
local SharedSickle = Load "Tools.Sickle.SharedSickle"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local localPlayer = game.Players.LocalPlayer

local remoteSickleAttempt = Load "Tools.Sickle.SickleAttempt"

----------------------------------------
----- Sickle Tool ----------------------
----------------------------------------


local ToolSickle = {}
ToolSickle.__index = ToolSickle
setmetatable(ToolSickle, Tool)

function ToolSickle.new(tool)
	local self = setmetatable(Tool.new(tool), ToolSickle)
	return self
end

function ToolSickle:OnActivated(mouse)

	local target = mouse.Target
	local point = mouse.Hit.p
	
	if SharedSickle.CanSickle(localPlayer, self.Object, target, point) then
		
		remoteSickleAttempt:FireServer(self.Object, target, point)
		return true
	end
	
end

function ToolSickle:IsInteractable(part, point)
	return SharedSickle.CanSickle(localPlayer, self.Object, part, point)
end

return ToolSickle