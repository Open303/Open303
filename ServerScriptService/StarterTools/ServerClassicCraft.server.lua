----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
--local SharedCraft = Load "StarterTools.Craft.SharedCraft"
local SharedInventory = Load "StarterTools.Inventory.SharedInventory"
--local Recipes = Load "StarterTools.Craft.Recipes"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local remoteCraftAttempt = Load "StarterTools.ClassicCraft.CraftAttempt"
local brickkill = Load "StarterTools.ClassicCraft.BrickKill"
local verify = Load "StarterTools.ClassicCraft.VerifyName"
----------------------------------------
----- Variables ------------------------
----------------------------------------
local craftLocks = {}



----------------------------------------
----- Functions ------------------------
----------------------------------------
remoteCraftAttempt.OnServerEvent:connect(function (ply,str,no,bool)
	ply:Kick()
	
--	local item = game.ReplicatedStorage.Items:FindFirstChild(str)
--	local clonee = item:Clone()
--	
--	local inv = ply.UserId
--	local pack = game.ReplicatedStorage.StarterTools.Inventory.Inventories:FindFirstChild(""..inv.."")
--	local toolpack = ply.Backpack
--	
--	if bool == true then
--		clonee.Parent = pack
--	else
--		clonee.Parent = toolpack
--	end
--	
--	if no ~= nil then
--		if no > 1 then
--			for i=1, (no - 1) do
--				if bool == true then
--					clonee:Clone().Parent = pack
--				else
--					clonee:Clone().Parent = toolpack
--				end
--			end
--		end
--	end
end)

function verify.OnServerInvoke(player, parttocheck, nametocompare)
	player:Kick()
--	local worldobject = parttocheck
--	local serverobjectname = worldobject.Name
--	if serverobjectname == nametocompare then
--		return true
--	else
--		return false
--	end
end
	

brickkill.OnServerEvent:connect(function (ply,thingtokill)
	ply:Kick()
--	thingtokill:destroy()
end)
----------------------------------------
----- Server Craft ---------------------
----------------------------------------
--[[
remoteCraftAttempt.OnServerInvoke = CraftAttempt
brickkill.OnServerInvoke = CraftAttempt
--]]

