----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local ToolMeleeWeapon = Load "Tools.MeleeWeapon.ToolMeleeWeapon"
local SharedKnife = Load "Tools.Knife.SharedKnife"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local localPlayer = game.Players.LocalPlayer

local remoteSliceAttempt = Load "Tools.Knife.SliceAttempt"
local remoteCarveAttempt = Load "Tools.Knife.CarveAttempt"

----------------------------------------
----- Knife Tool -----------------------
----------------------------------------
local ToolKnife = {}
ToolKnife.__index = ToolKnife
setmetatable(ToolKnife, ToolMeleeWeapon)

function ToolKnife.new(tool)
	local self = setmetatable(ToolMeleeWeapon.new(tool), ToolKnife)
	return self
end

function ToolKnife:OnActivated(mouse)
	local target = mouse.Target
	local point = mouse.Hit.p
	
	if SharedKnife.CanSlice(localPlayer, target, point) then
		local sliceTime = DataAccessor.Get(self.Object, "Tool.SliceTime")
		local slices = DataAccessor.Get(target, "Slices")
		
		remoteSliceAttempt:FireServer(target, point)
		return true, slices * sliceTime
	elseif SharedKnife.CanCarve(localPlayer, target, point) then
		remoteCarveAttempt:FireServer(target, point)
		return true
	end
	
	return ToolMeleeWeapon.OnActivated(self, mouse)
end

function ToolKnife:IsInteractable(part, point)
	return SharedKnife.CanCarve(localPlayer, part, point) or SharedKnife.CanSlice(localPlayer, part, point)
end

return ToolKnife