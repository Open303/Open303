----------------------------------------
----- Variables ------------------------
----------------------------------------
local locks = {}

----------------------------------------
----- Shared Lock Service --------------
----------------------------------------
local SharedLockService = {}

function SharedLockService.IsPartLocked(part)
	for player, testPart in pairs(locks) do
		if testPart == part then
			return true
		end
	end
	
	return false
end

function SharedLockService.GetLockingPlayer(part)
	for player, testPart in pairs(locks) do
		if testPart == part then
			return player
		end
	end
	
	return nil
end

function SharedLockService.AcquireLock(player, part)
	if SharedLockService.IsPartLocked(part) then
		return false
	end
	
	locks[player] = part
	
	return true
end

function SharedLockService.ReleaseLock(player)
	locks[player] = nil
end

function SharedLockService.SetPlayerLock(player, part)
	locks[player] = part
end

return SharedLockService