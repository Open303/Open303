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
----- Local Lock Service ---------------
----------------------------------------
remoteLockChanged.OnClientEvent:connect(SharedLockService.SetPlayerLock)

localAcquireLock.OnInvoke = SharedLockService.AcquireLock
localGetLockingPlayer.OnInvoke = SharedLockService.GetLockingPlayer
localIsPartLocked.OnInvoke = SharedLockService.IsPartLocked
localReleaseLock.OnInvoke = SharedLockService.ReleaseLock