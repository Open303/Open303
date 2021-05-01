local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local SharedInventory = Load "StarterTools.Inventory.SharedInventory"
local DataAccessor = Load "Data.DataAccessor"
local SharedOilFilter = Load "Tools.OilFilter.SharedOilFilter"
local PlayerCharacter = Load "Utility.PlayerCharacter"

local remoteOilFilterAttempt = Load "Tools.OilFilter.OilProcessAttempt"
local oilTemplate = Load "Items.Oil"

local function OnOilFilterAttempt(player, part, pointOnPart)
	local tool = PlayerCharacter.GetEquippedTool(player)
	
	if tool == nil or DataAccessor.Get(tool, "Tool.Class") ~= "OilFilter" then
		return
	end
	
	local processTime = DataAccessor.Get(tool, "Tool.FilterTime")
	
	if SharedOilFilter.CanFilter(player, part, pointOnPart) then
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
			oilTemplate:Clone().Parent = SharedInventory.GetPlayerInventory(player)
		end
	end
end

remoteOilFilterAttempt.OnServerEvent:connect(OnOilFilterAttempt)