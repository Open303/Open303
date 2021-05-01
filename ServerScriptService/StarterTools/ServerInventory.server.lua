----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local SharedInventory = Load "StarterTools.Inventory.SharedInventory"
local DataAccessor = Load "Data.DataAccessor"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local RunService = game:GetService("RunService")

local remotePlaceAt = Load "StarterTools.Inventory.PlaceAt"
local remoteActionOn = Load "StarterTools.Inventory.ActionOn"
local remoteRemoveArmor = Load "StarterTools.Inventory.RemoveArmor"

local itemBin = Load "Items"

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function PlaceAt(player, item, point)
	
	-- Store this in a variable so we can return it as well as check it.
	local result = SharedInventory.CanPlaceAt(player, item, point)
	
	-- If they can place it...
	if result then
		-- ...put it in the workspace, break any joints it had in its previous location, move it to the point, and make new joints.
		item.Parent = workspace
		item:BreakJoints()
		item.CFrame = CFrame.new(point+item.Size*Vector3.new(0,.5,0))
		item:MakeJoints()
	end
	
	-- Return the result regardless of whether it was true or false so the client can undo it.
	return result
end

local function ActionOn(player, item, target, pointOnTarget)
	local result = SharedInventory.CanPlaceAt(player, item, pointOnTarget)
	local action = SharedInventory.GetPlacementAction(item)
	local flammable = DataAccessor.Get(item, "Flammable")
	
	
	if not action or not result then
		return false
	end
	
	local usable = action.UsableOn(player, item, target)
	if not usable then
		return false
	end
	
	if flammable ~= nil then
		DataAccessor.Set(item, "Flammable", false)	
	end
	
	spawn(function() action.Act(player, item, target) end)
	return true
	
	
end

local function RemoveArmor(player)
	local armors = SharedInventory.GetEquippedArmors(player)
	
	if #armors > 0 then
		wait(5)
		for _, armor in ipairs(armors) do
			local name = DataAccessor.Get(armor, "ArmorName")
			itemBin:FindFirstChild(name):Clone().Parent = SharedInventory.GetPlayerInventory(player)
			armor:Destroy()
		end
	end
end

local function OnPlayerAdded(player)
	-- Create the inventory.
	SharedInventory.GetPlayerInventory(player)
end

local function OnPlayerRemoving(player)
	local playername = player.Name
	local inventory = SharedInventory.GetPlayerInventory(player)
	
	--print("LEAVING: "..playername.." has abandoned their items")

	if inventory then
		--print("CHECK: "..playername.."'s inventory exists")
		
		wait(60 * 15)
		
		--print("TIMEPASS: "..playername.." has been gone for the time period")
		local playercheck = game.Players:FindFirstChild(playername)
		
		if playercheck == nil then
			--print("NOTHERE: "..playername.." is still gone")
			inventory:Destroy()
		end
	end
end

----------------------------------------
----- Server Inventory -----------------
----------------------------------------
-- Yay, play solo.
for _, player in ipairs(game.Players:GetPlayers()) do
	OnPlayerAdded(player)
end

remotePlaceAt.OnServerEvent:connect(PlaceAt)
remoteActionOn.OnServerEvent:connect(ActionOn)
remoteRemoveArmor.OnServerInvoke = RemoveArmor

game.Players.PlayerAdded:connect(OnPlayerAdded)
game.Players.PlayerRemoving:connect(OnPlayerRemoving)