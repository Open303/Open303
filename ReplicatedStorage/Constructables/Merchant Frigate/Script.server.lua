local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"

function onPlayerLeave(oldPlayer)
	if oldPlayer == DataAccessor.Get(script.Parent, "Owner") then
		script.Parent:remove()
	end
end

game.Players.ChildRemoved:connect(onPlayerLeave)