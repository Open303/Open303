----------------------------------------
----- Constants ------------------------
----------------------------------------
-- How far away a player has to be to gather a part.
local GATHER_RANGE = 15

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local localGetLockingPlayer = Load "Locking.GetLockingPlayer"

----------------------------------------
----- Shared Gather --------------------
----------------------------------------
local SharedGather = {}

-- Returns whether a player can gather a part.
function SharedGather.CanGather(player, part, pointOnPart)
	if part == nil then
		return false
	end
	
	-- Obvious check.
	if not part:IsDescendantOf(workspace) then
		return false
	end
	
	-- If it's locked we should respect that.
	if part.Locked then
		return false
	end
	
	-- If the player's dead, don't let them do anything.
	if player.Character == nil or player.Character:FindFirstChild("Humanoid") == nil or player.Character.Humanoid.Health <= 0 then
		return false
	end
	
	-- If it's out of range, they can't grab it.
	if player:DistanceFromCharacter(pointOnPart) > GATHER_RANGE then
		return false
	end
	
	-- If they can't gather it directly and it's not a static resource, well, they can't gather it.
	if DataAccessor.GetFromAncestors(part, "DenyGather") == true and DataAccessor.Get(part, "GatherResult") == nil then
		return false
	end
	
	if DataAccessor.Get(part, "OnFire") then
		return false
	end
	
	-- If someone else has a lock on the part, they aren't allowed to mess with it.
	local lockOwner = localGetLockingPlayer:Invoke(part)
	if lockOwner ~= nil and lockOwner ~= player then
		return false
	end
	
	return true
end

-- Gets the actual gather result for a part.
-- For most parts this will just be the part itself.
-- However, some parts specify another result (sand, oil, etc.) and will return a copy of that instead.
function SharedGather.GetGatherResult(part)
	-- GatherResult is an ObjectValue.
	if DataAccessor.Get(part, "GatherResult") ~= nil then
		-- Return a copy.
		return DataAccessor.Get(part, "GatherResult"):Clone()
	else
		-- Return the part itself.
		return part
	end
end

-- Was going to have skill integration here but they're axed.
-- Just divide mass by 20.
function SharedGather.GetGatherTime(player, part)
	return part:GetMass() / 27.5
end

return SharedGather