local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local SharedSickle = Load "Tools.Sickle.SharedSickle"
local SharedInventory = Load "StarterTools.Inventory.SharedInventory"
local PlayerCharacter = Load "Utility.PlayerCharacter"

local remoteSickleAttempt = Load "Tools.Sickle.SickleAttempt"

local function OnSickleAttempt(player, tool, part, pointOnPart)
	local equippedTool = PlayerCharacter.GetEquippedTool(player)
	local esval = DataAccessor.Get(part.Parent, "ExtraSeed")
	local parent = part.Parent
		
	if equippedTool == nil or equippedTool ~= tool or DataAccessor.Get(equippedTool, "Tool.Class") ~= "Sickle" then
		return
	end
	
	parent.Data:destroy()
		
	for index, child in pairs(parent:GetChildren()) do
		child.Parent = SharedInventory.GetPlayerInventory(player)
	end
	
	if esval then
		local copy = esval:Clone()
		copy.Parent = SharedInventory.GetPlayerInventory(player)
	end		
end	
	
remoteSickleAttempt.OnServerEvent:connect(OnSickleAttempt)