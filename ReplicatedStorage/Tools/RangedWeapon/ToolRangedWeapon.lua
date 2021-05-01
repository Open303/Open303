----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local Tool = Load "Tools.Tool"
local SharedRangedWeapon = Load "Tools.RangedWeapon.SharedRangedWeapon"
local SharedInventory = Load "StarterTools.Inventory.SharedInventory"
local Scaffold = Load "UI.Scaffolder"
local AmmoCountScaffold = Load "Tools.RangedWeapon.AmmoCountScaffold"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local localPlayer = game.Players.LocalPlayer

local remoteAttackAttempt = Load "Tools.RangedWeapon.AttackAttempt"
local RecalculateTotal = Load "Tools.RangedWeapon.RecalculateTotal"

----------------------------------------
----- Weapon Tool ----------------------
----------------------------------------
local ToolRangedWeapon = {}
ToolRangedWeapon.__index = ToolRangedWeapon
setmetatable(ToolRangedWeapon, Tool)

function ToolRangedWeapon.new(tool)
	self = setmetatable(Tool.new(tool), ToolRangedWeapon)
	
	self.AmmoCountFrame = Scaffold(AmmoCountScaffold)
	self.AmmoCountFrame.Parent = self.Gui
	self.AmmoCountFrame.Visible = false
	self.AmmoLabel = self.AmmoCountFrame:FindFirstChild("AmmoText")
	
	return self
end

function ToolRangedWeapon:UpdateAmmoLabel()
	local ammos = SharedRangedWeapon.GetAllBestAmmo(localPlayer, self.Object)
		
	if #ammos > 0 then
		self.AmmoLabel.Text = "Firing "..ammos[1].Name.." ("..#ammos.." in inventory)"
	else
		self.AmmoLabel.Text = "No ammo in your inventory to fire!"
	end
end

function ToolRangedWeapon:OnEquipped()
	self.InventoryConnection = SharedInventory.GetPlayerInventory(localPlayer).ChildAdded:connect(function()
		self:UpdateAmmoLabel()
	end)
	
	self:UpdateAmmoLabel()
	
	self.AmmoCountFrame.Visible = true
end

function ToolRangedWeapon:OnUnequipped()
	if self.InventoryConnection then
		self.InventoryConnection:disconnect()
	end
	
	self.AmmoCountFrame.Visible = false
end



function ToolRangedWeapon:OnActivated(mouse)
	local target = mouse.Target
	local point = mouse.Hit.p
	
	if SharedRangedWeapon.CanAttack(localPlayer, self.Object, target, point) then
		
		remoteAttackAttempt:FireServer(self.Object, target, point)
		
		local armor = localPlayer.Character:FindFirstChild("ACTIVEARMOR")
		local cooldown = DataAccessor.Get(self.Object, "Tool.Cooldown")
		if armor ~= nil and DataAccessor.Get(armor, "FastReload") then
			cooldown = cooldown / 2
		end
		
				
		
		return true, cooldown
	end
	
	
	-- hehe
	return true
end

RecalculateTotal.OnClientEvent:connect(function()
	wait(.05)
	self:UpdateAmmoLabel()
end)

function ToolRangedWeapon:IsInteractable(part, point)
	return false
end

function ToolRangedWeapon:Swing()
	-- No-op to stop slashing animation from playing
end

return ToolRangedWeapon