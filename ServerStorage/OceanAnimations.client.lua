local RunService = game:GetService("RunService")

local ocean = workspace:WaitForChild("Ocean")
local waterMeshes = {}

-- Wait a tick for the ocean to replicate in (theoretically)
wait(0)

for _, oceanPart in ipairs(ocean:GetChildren()) do
	if oceanPart:FindFirstChild("WaterMesh") then
		table.insert(waterMeshes, oceanPart.WaterMesh)
	end
end

RunService.Heartbeat:Connect(function()
	local amplitude = math.sin(tick() / 5) / 4
	
	for _, mesh in ipairs(waterMeshes) do
		mesh.Offset = Vector3.new(0, amplitude, 0)
	end
end)