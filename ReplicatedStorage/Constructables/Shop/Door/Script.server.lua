wait(0.5)

local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"

local door = script.Parent

function openDoor()
	door.Transparency = 0.5
	door.CanCollide = false
	wait(1)
	door.Transparency = 0
	door.CanCollide = true
end

function onTouched(hit)
	if hit ~= nil then
		if hit.Parent ~= nil then
			local player = game.Players:GetPlayerFromCharacter(hit.Parent)

			if player ~= nil then
				if player == DataAccessor.Get(door.Parent, "Owner") then
					openDoor()
				end
			end
		end
	end
end

door.Touched:connect(onTouched)