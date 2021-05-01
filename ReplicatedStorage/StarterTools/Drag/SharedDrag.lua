----------------------------------------
----- Constants ------------------------
----------------------------------------
local DRAG_RANGE = 50
local REGION_NAME = "NoPlace"

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local Regions = Load "Utility.Regions"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local localGetLockingPlayer = Load "Locking.GetLockingPlayer"

----------------------------------------
----- Shared Drag ----------------------
----------------------------------------
local SharedDrag = {}

-- Checks whether a player can pick up a part and start dragging it.
-- If this returns false during a drag operation the player will drop the part.
function SharedDrag.CanPlayerDrag(player, part)
	if part == nil then
		return false
	end
	
	-- Obvious check is obvious.
	if not part:IsDescendantOf(workspace) then
		return false
	end
	
	-- If it's locked we should respect that, particularly for dragging.
	if part.Locked then
		return false
	end
	
	-- If anything in the ancestor tree up to the workspace has DenyDrag in it, don't allow dragging.
	if DataAccessor.GetFromAncestors(part, "DenyDrag") then
		return false
	end
	
	if DataAccessor.Get(part, "OnFire") then
		return false
	end
	
	-- If the player's dead, don't let them move it.
	if player.Character == nil or player.Character:FindFirstChild("Humanoid") == nil or player.Character:FindFirstChild("Humanoid").Health <= 0 then
		return false
	end
	
	-- If the part's out of range, don't let them move it.
	if player:DistanceFromCharacter(part.Position) > DRAG_RANGE then
		return false
	end
	
	if part.Parent ~= workspace then
		return false
	end
	
	-- If someone else is interacting with the part, only they can interact with it.
	-- Block moving if this is the case.
	local locker = localGetLockingPlayer:Invoke(part)
	if locker ~= nil and locker ~= player then
		return false
	end
	
	return true
end

function SharedDrag.CanDragToPoint(player, part, point)
	-- If they can't drag the part at all, they can't drag it to the point.
	if not SharedDrag.CanPlayerDrag(player, part) then
		return false
	end
	
	-- If they're in the NoPlace region they can't move a part into it, either.
	-- Out, sure. Not in.
	if Regions.IsPointInRegion(point, REGION_NAME) then
		return false
	end
	
	return true
end

return SharedDrag