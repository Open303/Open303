-- Contains shared consume code.

----------------------------------------
----- Constants ------------------------
----------------------------------------
local CONSUME_RANGE = 15

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local SharedStats = Load "Stats.SharedStats"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local RunService = game:GetService("RunService")

----------------------------------------
----- Shared Consume -------------------
----------------------------------------
local SharedConsume = {}

function SharedConsume.IsInRange(player, mousePoint)
	return player.Character ~= nil and player:DistanceFromCharacter(mousePoint) <= CONSUME_RANGE
end

function SharedConsume.IsEdible(part)
	local edibleData = DataAccessor.GetFromAncestors(part, "Edible")
	
	if not edibleData then
		return false
	end
	
	if not edibleData.Portions or edibleData.Portions <= 0 then
		return false
	end
	
	if part.Locked then
		return false
	end
	
	return true
end

function SharedConsume.GetEdibleObject(part)
	local level = part
	
	while true do
		if SharedConsume.IsEdible(level) then
			return level
		else
			level = level.Parent
			
			if not level then
				return nil
			end
		end
	end
end

function SharedConsume.Consume(player, part, mousePoint)
	if not part or not mousePoint then
		return
	end
	
	if not SharedConsume.IsInRange(player, mousePoint) or not SharedConsume.IsEdible(part) then
		return
	end
	
	local edibleObject = SharedConsume.GetEdibleObject(part)
	local edibleData = DataAccessor.GetFromAncestors(edibleObject, "Edible")
	
	if edibleData.Portions <= 0 then
		return
	end
	
	local statChanges = {
		Vitality = edibleData.Vitality - edibleData.Poison;
		Hunger = edibleData.Hunger;
		Thirst = edibleData.Thirst;
		Saturation = edibleData.Saturation;
	}
	
	for statName, change in pairs(statChanges) do
		SharedStats.Increment(player, statName, change)
	end
	
	DataAccessor.Increment(edibleObject, "Edible.Portions", -1)
	
	-- Declared here so the undo can remove it
	local copy, originalParent
	
	if DataAccessor.Get(edibleObject, "Edible.Portions") <= 0 then
		if edibleData.ReplacementItem and RunService:IsServer() then
			copy = edibleData.ReplacementItem:Clone()
			copy.CFrame = part.CFrame
			copy.Parent = part.Parent
			copy:MakeJoints()
		end
		
		if not edibleData.LeaveOnDepletion then
			originalParent = edibleObject.Parent
			edibleObject.Parent = nil
		end
	end
	
	return function()
		if copy then
			edibleObject.CFrame = copy.CFrame
			copy:Destroy()
		end
		
		edibleObject.Parent = originalParent
		pcall(workspace.MakeJoints, edibleObject)
		DataAccessor.Increment(edibleObject, "Edible.Portions", 1)
		
		for statName, change in pairs(statChanges) do
			SharedStats.Increment(player, statName, -change)
		end
	end
end

return SharedConsume