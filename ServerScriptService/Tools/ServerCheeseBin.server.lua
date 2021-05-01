local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local SharedInventory = Load "StarterTools.Inventory.SharedInventory"
local DataAccessor = Load "Data.DataAccessor"
local SharedCheeseBin = Load "Tools.CheeseBin.SharedCheeseBin"
local PlayerCharacter = Load "Utility.PlayerCharacter"

local remoteBinProcessAttempt = Load "Tools.CheeseBin.BinProcessAttempt"
local cheeseTemplate = Load "Items.Mozarella"

local function OnBinProcessAttempt(player, part, pointOnPart)
	local tool = PlayerCharacter.GetEquippedTool(player)
	
	if tool == nil or DataAccessor.Get(tool, "Tool.Class") ~= "CheeseBin" then
		return
	end
	
	local processTime = DataAccessor.Get(tool, "Tool.ProcessTime")
	
	if SharedCheeseBin.CanBin(player, part, pointOnPart) then
		-- Prevent people from starting filtering, storing the tool, then unstoring it
		local connection, wasRemoved
		connection = tool.Changed:connect(function(property)
			if tool.Parent ~= player.Backpack and tool.Parent ~= player.Character then
				wasRemoved = true
			end
		end)
		
		DataAccessor.Set(tool, "Working", true)
		
		part:Destroy()
		wait(processTime)
		DataAccessor.Set(tool, "Working", false)
		if not wasRemoved then
			connection:disconnect()
			cheeseTemplate:Clone().Parent = SharedInventory.GetPlayerInventory(player)
		end
	end
end

remoteBinProcessAttempt.OnServerEvent:connect(OnBinProcessAttempt)