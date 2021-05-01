----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local Tool = Load "Tools.Tool"
local ToolMeleeWeapon = Load "Tools.MeleeWeapon.ToolMeleeWeapon"
local SharedMeleeWeapon = Load "Tools.MeleeWeapon.SharedMeleeWeapon"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local localPlayer = game.Players.LocalPlayer

local remoteAttackAttempt = Load "Tools.MeleeWeapon.AttackAttempt"

----------------------------------------
----- Weapon Tool ----------------------
----------------------------------------
local Sabre = {}
Sabre.__index = Sabre
setmetatable(Sabre, ToolMeleeWeapon)

function Sabre.new(tool)
	local self = setmetatable(ToolMeleeWeapon.new(tool), Sabre)
	return self
end

function Sabre:Swing()
	--put code to run animation here
	--leaving this blank will prevent animations on swing
	--self.Object references the tool object, which will be inside the player
end

function Tool:OnEquipped(mouse)
	--idle animation likely lives here	
end

function Tool:OnUnequipped()
	--other half of idle animation	
end

return Sabre