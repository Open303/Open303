-- Prevents players from being seated into the terrain.

local Players = game:GetService("Players")

--local SeatRecords = {}

local function IsBlocked(character)
	local humanoid = character:FindFirstChild("Humanoid")
	
	if not humanoid or not humanoid.SeatPart then return end
	local seat = humanoid.SeatPart
	
	local part = workspace:FindPartOnRay(Ray.new(seat.Position, seat.CFrame:vectorToWorldSpace(Vector3.new(0, 3, 0))), character)
	return part ~= nil
end
--[[
local function IncrementSeatRecord(seat)
	SeatRecords[seat] = (SeatRecords[seat] or 0) + 1
	
	if SeatRecords[seat] >= 2 then
		seat:Destroy()
		SeatRecords[seat] = nil
	else
		delay(60, function()
			if SeatRecords[seat] then
				SeatRecords[seat] = SeatRecords[seat] - 1
			end
		end)
	end
end
--]]
local function OnCharacterAdded(character)
	local humanoid = character:WaitForChild("Humanoid")
	
	humanoid.Seated:connect(function(_, seat)
		wait(0)
		
		if IsBlocked(character) then
			humanoid.Sit = false
			wait(0)
			character:SetPrimaryPartCFrame(CFrame.new(character:GetPrimaryPartCFrame().p) + Vector3.new(0, 2+character:GetExtentsSize().Y, 0))
			-- stop them from flying everywhere
			character.PrimaryPart.Velocity = Vector3.new()
			character.PrimaryPart.RotVelocity = Vector3.new()
			-- ensure player can walk immediately
			humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
			-- stop the seat from being flung
			seat.Velocity = Vector3.new(0, 0, 0)
			--IncrementSeatRecord(seat)
		end
	end)
end

local function OnPlayerAdded(player)
	if player.Character then
		OnCharacterAdded(player.Character)
	end
	
	player.CharacterAdded:connect(OnCharacterAdded)
end

for _, player in ipairs(Players:GetPlayers()) do
	OnPlayerAdded(player)
end

Players.PlayerAdded:connect(OnPlayerAdded)