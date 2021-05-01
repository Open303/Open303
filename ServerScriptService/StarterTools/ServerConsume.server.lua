-- Server-side proxy and validator for the consume tool.

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local SharedConsume = Load "StarterTools.Consume.SharedConsume"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local remoteConsumeAttempt = Load "StarterTools.Consume.ConsumeAttempt"

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function ConsumeAttempt(player, part, point)
	if not part or not point then
		return false
	end
	
	if not SharedConsume.IsInRange(player, point) or not SharedConsume.IsEdible(part) then
		return false
	end
	
	if not part:IsDescendantOf(workspace) then
		return false
	end
	
	SharedConsume.Consume(player, part, point)
	return true
end

----------------------------------------
----- Main Script ----------------------
----------------------------------------
remoteConsumeAttempt.OnServerInvoke = ConsumeAttempt