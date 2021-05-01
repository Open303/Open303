local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local SharedHarvesting = Load "Tools.Harvesting.SharedHarvesting"
local SharedInventory = Load "StarterTools.Inventory.SharedInventory"
local PlayerCharacter = Load "Utility.PlayerCharacter"

local remoteHarvestAttempt = Load "Tools.Harvesting.HarvestAttempt"

local function OnHarvestAttempt(player, tool, part, pointOnPart)
	local equippedTool = PlayerCharacter.GetEquippedTool(player)
	
	if equippedTool == nil or equippedTool ~= tool or DataAccessor.Get(equippedTool, "Tool.Class") ~= "Harvesting" then
		return
	end
	
	if SharedHarvesting.CanHarvest(player, tool, part, pointOnPart) and math.random() <= DataAccessor.Get(tool, "Tool.HarvestChance") then
		part.Parent = SharedInventory.GetPlayerInventory(player)
	end
end

remoteHarvestAttempt.OnServerEvent:connect(OnHarvestAttempt)