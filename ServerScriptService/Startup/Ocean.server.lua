----------------------------------------
----- Constants ------------------------
----------------------------------------
local GRID_SIZE = 1024
-- How many studs to add to the workspace's bounds to create an ocean bigger than the map
local EXTENTS_PADDING = 4096
local FLOOR_LEVEL = 0.5
local SEA_LEVEL = 25

----------------------------------------
----- Objects --------------------------
----------------------------------------
local floorTemplate = script.OceanFloor
local wallTemplate = script.OceanWall
local waterTemplate = script.Water
local waterOverlayTemplate = script.TopWater
local center = workspace.StartupObjects.OceanCenter

----------------------------------------
----- Variables ------------------------
----------------------------------------
local waterParts = {}

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function GetGridSize()
	local workspaceBounds = workspace:GetExtentsSize()
	
	local gridX = math.ceil((workspaceBounds.X + EXTENTS_PADDING) / GRID_SIZE)
	local gridZ = math.ceil((workspaceBounds.Z + EXTENTS_PADDING) / GRID_SIZE)
	
	return gridX, gridZ
end

local function GetWorldPosition(gridX, gridZ)
	local centerPoint = center.Position
	local gridWidth, gridHeight = GetGridSize()
	local offsetX = gridX - gridWidth / 2
	local offsetZ = gridZ - gridHeight / 2
	
	return math.floor(offsetX * GRID_SIZE + centerPoint.X), math.floor(offsetZ * GRID_SIZE + centerPoint.Z)
end

local function BuildGrid()
	local container = Instance.new("Folder")
	container.Name = "Ocean"
	
	local gridWidth, gridHeight = GetGridSize()
	
	for x = 1, gridWidth do
		for z = 1, gridHeight do
			local worldX, worldZ = GetWorldPosition(x, z)
			
			local floor = floorTemplate:Clone()
			floor.Size = Vector3.new(GRID_SIZE, 1, GRID_SIZE)
			floor.CFrame = CFrame.new(worldX, FLOOR_LEVEL, worldZ)
			floor.Parent = container
			
			local water = waterTemplate:Clone()
			water.Size = Vector3.new(GRID_SIZE, 1, GRID_SIZE)
			water.CFrame = CFrame.new(worldX, SEA_LEVEL, worldZ)
			water.Parent = container
			
			water.Touched:connect(function(part)
				if part.Parent ~= workspace then return end
				
				part:BreakJoints()
				wait(5)
				if part.Parent == workspace then
					part:Destroy()
				end
			end)
			
			table.insert(waterParts, water)
			
			local waterOverlay = waterOverlayTemplate:Clone()
			waterOverlay.Size = Vector3.new(GRID_SIZE, 1.2, GRID_SIZE)
			waterOverlay.CFrame = CFrame.new(worldX, SEA_LEVEL, worldZ)
			waterOverlay.Parent = container
			
			if x == 1 or x == gridWidth then
				local offset = x == 1 and -GRID_SIZE / 2 or GRID_SIZE / 2
				local wall = wallTemplate:Clone()
				wall.Size = Vector3.new(1, SEA_LEVEL + 4, GRID_SIZE)
				wall.CFrame = CFrame.new(worldX + offset, SEA_LEVEL / 2 + 2, worldZ)
				wall.Parent = container
			end
			
			if z == 1 or z == gridHeight then
				local offset = z == 1 and -GRID_SIZE / 2 or GRID_SIZE / 2
				local wall = wallTemplate:Clone()
				wall.Size = Vector3.new(GRID_SIZE, SEA_LEVEL + 4, 1)
				wall.CFrame = CFrame.new(worldX, SEA_LEVEL / 2 + 2, worldZ + offset)
				wall.Parent = container
			end
		end
	end
	
	container.Parent = workspace
end

----------------------------------------
---- Ocean -----------------------------
----------------------------------------
BuildGrid()
center:Destroy()

while true do
	wait(5)
	for _, waterPart in ipairs(waterParts) do
		waterPart:BreakJoints()
	end
end