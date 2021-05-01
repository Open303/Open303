local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local SharedInventory = Load "StarterTools.Inventory.SharedInventory"
local DataAccessor = Load "Data.DataAccessor"
local SharedFishing = Load "Tools.Fishing.SharedFishing"
local PlayerCharacter = Load "Utility.PlayerCharacter"
local Hierarchy = Load "Utility.Hierarchy"
local Damage = Load "Utility.Damage"
local remoteFishingAttempt = Load "Tools.Fishing.FishingAttempt"



		-- I am WELL AWARE the following sectiosn are GODAWFUL. No one else was around to do this, so I did. Please, rewrite away - I've got no attachment to this.	
		
local SharedInventory = Load "StarterTools.Inventory.SharedInventory"

local function OnFishingAttempt(player, tool, part, pointOnPart)
	
	local fish = game.ReplicatedStorage.Fish	
	
	local equippedTool = PlayerCharacter.GetEquippedTool(player)
	local ToolQuality = DataAccessor.Get(equippedTool, "Tool.FishingTier")	
	
	if equippedTool == nil or equippedTool ~= tool or DataAccessor.Get(equippedTool, "Tool.Class") ~= "Fishing" then
		return
	end
	
	local fishfolder = fish["Tier 4"]
	
	if ToolQuality == 3 then
		fishfolder = fish["Tier 3"]
	elseif ToolQuality == 2 then
		fishfolder = fish["Tier 2"]
	elseif ToolQuality == 1 then
		fishfolder = fish["Tier 1"]
	end

	
	if SharedFishing.CanFish(player, tool, part, pointOnPart) then

		local possibles = {}
		
		wait(.01)
		
		for _, fishfolder in ipairs(fishfolder:GetChildren()) do
			table.insert(possibles, fishfolder)
		end
		
		local yield = possibles[math.random(1, #possibles)]
		local CopyYield = yield:clone()
		
		local inventory = SharedInventory.GetPlayerInventory(player)
			

		
		if ToolQuality == 2 then

			for i=1, math.random(1,3) do
				yield:Clone().Parent = inventory
			end
		else
			CopyYield.Parent = inventory			
		end
	end
end

remoteFishingAttempt.OnServerEvent:connect(OnFishingAttempt)