local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local SharedInventory = Load "StarterTools.Inventory.SharedInventory"
local DataAccessor = Load "Data.DataAccessor"
local SharedMeleeWeapon = Load "Tools.MeleeWeapon.SharedMeleeWeapon"
local PlayerCharacter = Load "Utility.PlayerCharacter"
local Hierarchy = Load "Utility.Hierarchy"
local Damage = Load "Utility.Damage"

local remoteAttackAttempt = Load "Tools.MeleeWeapon.AttackAttempt"

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
	
	local damage = DataAccessor.Get(tool, "Tool.Damage")
	
	for pattern, multiplier in pairs(damageTable) do
		if part.Name:match(pattern) then
			damage = damage * multiplier
		end
	end
	
	if SharedMeleeWeapon.CanAttack(player, tool, part, pointOnPart) then
		local humanoid = PlayerCharacter.GetHumanoidFromPart(part)
		Damage(humanoid, damage, "Melee")
		
		if DataAccessor.Get(tool, "Tool.Thrown") then
			local transparencies = {}
			
			for _, descendant in ipairs(Hierarchy.GetDescendants(tool)) do
				if descendant:IsA("BasePart") then
					transparencies[descendant] = descendant.Transparency
					descendant.Transparency = 1
				end
			end
			
			wait(DataAccessor.Get(tool, "Tool.Cooldown"))

			for descendant, originalTransparency in pairs(transparencies) do
				descendant.Transparency = originalTransparency
			end
		end
	end
end

remoteAttackAttempt.OnServerEvent:connect(OnAttackAttempt)