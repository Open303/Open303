local Players = game:GetService("Players")

local function OnCharacterAdded(player)
	return function(character)
		local humanoid = character:WaitForChild("Humanoid")
		local currentSeat = nil
		
		humanoid.Seated:Connect(function(active, seat)
			if active and seat ~= nil and seat:IsA("VehicleSeat") and seat:FindFirstChild("BodyVelocity") and seat:FindFirstChild("BodyAngularVelocity") then
				pcall(seat.SetNetworkOwner, seat, player)
				currentSeat = seat
			elseif currentSeat ~= nil then
				pcall(currentSeat.SetNetworkOwnershipAuto, currentSeat)
				currentSeat = nil
			end
		end)
	end
end

local function OnPlayerAdded(player)
	local listener = OnCharacterAdded(player)
	
	if player.Character ~= nil then
		listener(player.Character)
	end
	
	player.CharacterAdded:Connect(listener)
end

for _, player in ipairs(Players:GetPlayers()) do
	OnPlayerAdded(player)
end

Players.PlayerAdded:Connect(OnPlayerAdded)
