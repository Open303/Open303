----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local SharedDrag = Load "StarterTools.Drag.SharedDrag"

----------------------------------------
----- Objects --------------------------
----------------------------------------
-- Locking communication objects.
local localAcquireLock = Load "Locking.AcquireLock"
local localReleaseLock = Load "Locking.ReleaseLock"
-- Networking event objects.
local remoteDragStart = Load "StarterTools.Drag.DragStart"
local remoteDragUpdate = Load "StarterTools.Drag.DragUpdate"
local remoteDragEnd = Load "StarterTools.Drag.DragEnd"

----------------------------------------
----- Variables ------------------------
----------------------------------------
-- Holds what parts players are dragging.
-- Primarily used for validation.
-- Form: [player] = part
local dragging = {}
local anchoredState = {}

----------------------------------------
----- Functions ------------------------
----------------------------------------
-- Fired when a client starts a drag.
local function OnDragStart(player, part)
	-- Just check it
	if not SharedDrag.CanPlayerDrag(player, part) then
		return
	end
	
	-- Players can drag some resources
	-- If they do, we should remove it from the resource model so they regenerate.
	if part:IsDescendantOf(workspace.Resources) then
		part.Parent = workspace
	end
	
	-- Acquire lock so someone else can't gather this or something.
	localAcquireLock:Invoke(player, part)
	-- Record that the player's dragging this part.
	dragging[player] = part
	-- Store the anchored state and anchor this part.
	anchoredState[part] = part.Anchored
	part.Anchored = true
end

-- Fired when a client updates a drag that started before.
-- The dragging part is referenced from dragging.
local function OnDragUpdate(player, cframe, mousePoint)
	local part = dragging[player]
	
	-- If somehow the client is out of sync or network events are going back and forth, discard it.
	if part == nil then
		return
	end
	
	-- If they can't drag, just discard silently.
	-- Trying to synchronize updates and undo them on the client is too much work for an edge case.
	-- If it becomes an issue this may change but whatever.
	if not SharedDrag.CanDragToPoint(player, part, mousePoint) then
		return
	end
	
	part:BreakJoints()
	-- If we passed all the checks, we can update the CFrame.
	part.CFrame = cframe
	part:MakeJoints()
end

local function OnDragEnd(player)
	-- If they're not dragging anything, don't clobber their lock (on some other part!)
	local part = dragging[player]
	if part == nil then return end
	
	part:MakeJoints()
	
	-- Clear part. Not technically necessary but good practice to clean up.
	dragging[player] = nil
	-- Unanchor the part if it was anchored before; clear the record.
	part.Anchored = anchoredState[part]
	anchoredState[part] = nil
	-- Release the lock so other players can interact with the part.
	localReleaseLock:Invoke(player)
end

----------------------------------------
----- Server Drag ----------------------
----------------------------------------
remoteDragStart.OnServerEvent:connect(OnDragStart)
remoteDragUpdate.OnServerEvent:connect(OnDragUpdate)
remoteDragEnd.OnServerEvent:connect(OnDragEnd)