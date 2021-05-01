local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local SharedInventory = Load "StarterTools.Inventory.SharedInventory"
local DataAccessor = Load "Data.DataAccessor"
local SharedRangedWeapon = Load "Tools.RangedWeapon.SharedRangedWeapon"
local PlayerCharacter = Load "Utility.PlayerCharacter"
local Hierarchy = Load "Utility.Hierarchy"
local Damage = Load "Utility.Damage"

local remoteAttackAttempt = Load "Tools.RangedWeapon.AttackAttempt"
local RecalculateTotal = Load "Tools.RangedWeapon.RecalculateTotal"

local damageTable = {
	["Head"] = 2;
	[".-Leg"] = 0.75;
	[".-Arm"] = 0.5;
}

local function OnAttackAttempt(player, tool, part, pointOnPart)
	local equippedTool = PlayerCharacter.GetEquippedTool(player)
	
	if equippedTool == nil or equippedTool ~= tool then
		return
	end
	
	local baseDamage = DataAccessor.Get(tool, "Tool.BaseDamage")
	local bestAmmo = SharedRangedWeapon.GetBestAmmo(player, tool)
	
	if bestAmmo == nil then
		return
	end
	
	local damage = baseDamage + DataAccessor.Get(bestAmmo, "AmmoDamage")
	
	for pattern, multiplier in pairs(damageTable) do
		if part.Name:match(pattern) then
			damage = damage * multiplier
		end
	end
	
	local armor = player.Character:FindFirstChild("ACTIVEARMOR")
	
	if armor ~= nil and DataAccessor.Get(armor, "RangedMultiplier") ~= nil then
		damage = damage * DataAccessor.Get(armor, "RangedMultiplier")
	end
	
	if SharedRangedWeapon.CanAttack(player, tool, part, pointOnPart) then
		local humanoid = PlayerCharacter.GetHumanoidFromPart(part)
		Damage(humanoid, damage, "Range")
		bestAmmo:Destroy()
		RecalculateTotal:FireClient(player)
	end
end

remoteAttackAttempt.OnServerEvent:connect(OnAttackAttempt)