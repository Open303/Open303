----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local SharedGather = Load "StarterTools.Gather.SharedGather"
local SharedInventory = Load "StarterTools.Inventory.SharedInventory"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local remoteGatherAttempt = Load "StarterTools.Gather.GatherAttempt"
local remoteGatherAbort = Load "StarterTools.Gather.GatherAbort"
local localAcquireLock = Load "Locking.AcquireLock"
local localReleaseLock = Load "Locking.ReleaseLock"

----------------------------------------
----- Variables ------------------------
----------------------------------------
-- Stores gather start ticks for players.
-- Used to handle gather aborts.
local gathering = {}

----------------------------------------
----- Functions ------------------------
----------------------------------------
-- Called when a player starts to gather a part.
-- If they can't gather the part, immediately return false.
-- Otherwise, wait for the computed gather time of the part, then return true.
local function GatherAttempt(player, part, pointOnPart)
	if SharedGather.CanGather(player, part, pointOnPart) then
		-- Store the time so they can abort it later.
		local currentTick = tick()
		gathering[player] = currentTick
		
		-- Get the actual result - if it's sand or oil or snow it isn't the actual part they clicked
		local result = SharedGather.GetGatherResult(part)
		
		-- Lock the part if and only if the player is gathering the actual part they clicked
		-- If they aren't, it's a static resource and doesn't need to be locked (because it can't be gathered directly)
		if result == part then
			localAcquireLock:Invoke(player, part)
		end
		
		-- Wait it out
		wait(SharedGather.GetGatherTime(player, result))
		
		-- If they didn't abort it between starting the wait and here, go ahead and gather it.
		if gathering[player] == currentTick then
			-- If it's caught fire or something between gather start and gather end, they shouldn't pick it up anyway.
			if SharedGather.CanGather(player, part, pointOnPart) then
				local inventory = SharedInventory.GetPlayerInventory(player)
				
				while true do
					local success = pcall(function() result.Parent = inventory	end)
					if success then
						break
					else
						wait(0)
					end
				end
			end
			
			-- Release the lock so when they drop it someone else can use it.
			localReleaseLock:Invoke(player)
			
			return true
		end
	end
	
	-- If we got here, either the player aborted the gather at some point or couldn't gather it
	-- Return false.
	return false
end

-- Called when the player requests an abort.
local function OnGatherAbort(player)
	-- Clear the gather flag so they can gather the part.
	gathering[player] = nil
end

----------------------------------------
----- Server Gather --------------------
----------------------------------------
remoteGatherAttempt.OnServerInvoke = GatherAttempt
remoteGatherAbort.OnServerEvent:connect(OnGatherAbort)