----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local PlayerCharacter = Load "Utility.PlayerCharacter"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local localPlayer = game.Players.LocalPlayer
local humanoid = PlayerCharacter.WaitForCurrentHumanoid(localPlayer)
local currentSeatConnection = nil

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function OnSeated(active, seat)
	if active and seat ~= nil and seat:IsA("VehicleSeat") then
		local thruster = seat:FindFirstChild("BodyVelocity")
		local rotator = seat:FindFirstChild("BodyAngularVelocity")
		
		if thruster == nil or rotator == nil then
			return
		end
		
		local maxSpeed = seat.MaxSpeed
		local maxTurnSpeed = seat.TurnSpeed
		
		local function AdjustSpeed()
			if seat.Parent:FindFirstChild("Sail") == nil or seat.Parent:FindFirstChild("Sail") == nil then
				maxSpeed = maxSpeed / 2
			else
				local childRemovedConnection
				childRemovedConnection = seat.Parent.ChildRemoved:Connect(function(child)
					if child.Name == "Sail" or child.Name == "Mast" then
						maxSpeed = maxSpeed / 2
						childRemovedConnection:Disconnect()
					end
				end)
			end
		end

		currentSeatConnection = seat.Changed:Connect(function(property)
			if property == "Throttle" then
				thruster.Velocity = seat.CFrame.lookVector * maxSpeed * seat.Throttle
			elseif property == "Steer" then
				local steer = seat.Steer
				rotator.AngularVelocity = Vector3.new(0, maxTurnSpeed * -steer, 0)
				
				while seat.Steer == steer and currentSeatConnection.Connected do
					thruster.Velocity = seat.CFrame.lookVector * maxSpeed * seat.Throttle
					wait(0)
				end
			end
		end)
		
		AdjustSpeed()
	elseif currentSeatConnection ~= nil and currentSeatConnection.Connected then
		currentSeatConnection:Disconnect()
	end
end

----------------------------------------
----- Event Connections ----------------
----------------------------------------
humanoid.Seated:Connect(OnSeated)
humanoid.Died:Connect(function()
	if currentSeatConnection ~= nil and currentSeatConnection.Connected then
		currentSeatConnection:Disconnect()
	end
end)
