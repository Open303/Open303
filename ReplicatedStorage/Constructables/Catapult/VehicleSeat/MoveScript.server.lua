local seat = script.Parent
local bv = seat:WaitForChild("BodyVelocity")
local bav = seat:WaitForChild("BodyAngularVelocity")

local maxSpeed = seat.MaxSpeed
local maxRotSpeed = seat.TurnSpeed

bv.velocity = Vector3.new(0,0,0)

seat.Changed:connect(function(prop)
	if prop == "Throttle" then
		bv.velocity = seat.CFrame.lookVector * (maxSpeed*seat.Throttle)
	elseif prop == "Steer" then
		local steer = seat.Steer
		bav.angularvelocity = Vector3.new(0, maxRotSpeed * -seat.Steer, 0)
		while seat.Steer == steer do
			bv.velocity = seat.CFrame.lookVector * (maxSpeed*seat.Throttle)
			wait()
		end
	end
end)