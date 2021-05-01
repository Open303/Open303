local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local SharedInventory = Load "StarterTools.Inventory.SharedInventory"
local DataAccessor = Load "Data.DataAccessor"
local SharedMilker = Load "Tools.Milker.SharedMilker"
local PlayerCharacter = Load "Utility.PlayerCharacter"

local remoteMilkAttempt = Load "Tools.Milker.MilkAttempt"
local milkTemplate = Load "Items.Milk"

local function OnMilkAttempt(player, part, pointOnPart)
	local tool = PlayerCharacter.GetEquippedTool(player)
	
	if tool == nil or DataAccessor.Get(tool, "Tool.Class") ~= "Milker" then
		return
	end
	
	local processTime = DataAccessor.Get(tool, "Tool.MilkTime")
	
	if SharedMilker.CanMilk(player, part, pointOnPart) then
		-- Prevent people from starting filtering, storing the tool, then unstoring it
		local connection, wasRemoved
		connection = tool.Changed:connect(function(property)
			if tool.Parent ~= player.Backpack and tool.Parent ~= player.Character then
				wasRemoved = true
			end
		end)
		
		DataAccessor.Set(tool, "Working", true)
		wait(processTime)
		DataAccessor.Set(tool, "Working", false)
		if not wasRemoved then
			connection:disconnect()
			milkTemplate:Clone().Parent = SharedInventory.GetPlayerInventory(player)
		end
	end
end

remoteMilkAttempt.OnServerEvent:connect(OnMilkAttempt)