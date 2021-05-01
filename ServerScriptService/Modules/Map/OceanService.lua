-- Ocean service.
-- Handles generation of the ocean.

local import = require(game:GetService("ReplicatedStorage"):WaitForChild("Import"))
local Environment = import "~/Environment"

local OceanService = {}

OceanService.SeaLevel = 24
OceanService.OceanCenter = Environment.Containers.Startup.OceanCenter.Position
OceanService.GridCellSize = 1024
OceanService.ExtentsPadding = 2048

-- Not super fond of this, but who knows
print("[OceanService]: Ocean center set to {"..tostring(OceanService.OceanCenter).."}; destroying marker.")
Environment.Containers.Startup.OceanCenter:Destroy()

local workspaceBounds = workspace:GetExtentsSize()
local gridWidth = math.ceil((workspaceBounds.X + OceanService.ExtentsPadding) / OceanService.GridCellSize)
local gridLength = math.ceil((workspaceBounds.Z + OceanService.ExtentsPadding) / OceanService.GridCellSize)

-- Converts a grid position to the center of the grid cell's world position, in x/z coordinates.
local function GetWorldPosition(gridX, gridZ)
	local offsetX = gridX - gridWidth / 2
	local offsetZ = gridZ - gridLength / 2
	local x = math.floor(offsetX * OceanService.GridCellSize + OceanService.OceanCenter.X)
	local z = math.floor(offsetZ * OceanService.GridCellSize + OceanService.OceanCenter.Z)
	
	return x, z
end

function OceanService:Generate()
	-- Don't need to double-generate the ocean
	if OceanService.HasGenerated then
		warn("[OceanService]: Ocean has already generated!")
		return
	end
	
	local startTick = tick()
	print("[OceanService]: Generating smooth terrain ocean.")
	for x = 1, gridWidth do
		for z = 1, gridLength do
			local worldX, worldZ = GetWorldPosition(x, z)
			
			-- Fill the ocean first
			workspace.Terrain:FillBlock(
				CFrame.new(worldX, OceanService.OceanCenter.Y + OceanService.SeaLevel / 2, worldZ), 
				Vector3.new(OceanService.GridCellSize + 8, OceanService.SeaLevel, OceanService.GridCellSize + 8), 
				Enum.Material.Water)
			
			-- Then fill in the ocean floor
			-- This prevents the water from overwriting the floor if the positioning gets messed up
			workspace.Terrain:FillBlock(
				CFrame.new(worldX, OceanService.OceanCenter.Y, worldZ), 
				Vector3.new(OceanService.GridCellSize + 8, 4, OceanService.GridCellSize + 8), 
				Enum.Material.Rock)
		end
	end
	print("[OceanService]: Ocean generated in "..tick() - startTick.." seconds.")
	
	workspace.Terrain.Touched:Connect(function(part)
		if part.Parent == workspace then
			wait(30)
			if part.Parent == workspace then
				part:Destroy()
			end
		elseif part.Parent:IsA("Tool") and part.Parent.Parent == workspace then
			wait(30)
			if part.Parent:IsA("Tool") and part.Parent.Parent == workspace then
				part.Parent:Destroy()
			end
		end
	end)
end

return OceanService
