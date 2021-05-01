----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local SharedLockService = Load "Locking.SharedLockService"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local remoteLockChanged = Load "Locking.LockChanged"
local localAcquireLock = Load "Locking.AcquireLock"
local localGetLockingPlayer = Load "Locking.GetLockingPlayer"
local localIsPartLocked = Load "Locking.IsPartLocked"
local localReleaseLock = Load "Locking.ReleaseLock"

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function AcquireLock(player, part)
	local result = SharedLockService.AcquireLock(player)
	
	if result then
		remoteLockChanged:FireAllClients(player, part)
	end
	
	return result
end

local function ReleaseLock(player, part)
	SharedLockService.ReleaseLock(player)
	remoteLockChanged:FireAllClients(player, nil)
end

----------------------------------------
----- Server Lock Service --------------
----------------------------------------
localAcquireLock.OnInvoke = AcquireLock
localGetLockingPlayer.OnInvoke = SharedLockService.GetLockingPlayer
localIsPartLocked.OnInvoke = SharedLockService.IsPartLocked
localReleaseLock.OnInvoke = ReleaseLock