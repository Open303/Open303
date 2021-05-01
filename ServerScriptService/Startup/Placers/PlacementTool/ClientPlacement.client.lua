----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local SharedPlacement = Load "Placement.SharedPlacement"
local Hierarchy = Load "Utility.Hierarchy"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local localPlayer = game.Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local character = localPlayer.Character or localPlayer.CharacterAdded:wait()
local humanoid = character:WaitForChild("Humanoid")
local tool = script.Parent

local preview = Load("Constructables."..tool.Name):Clone()
local remotePlaceAttempt = Load "Placement.PlacementAttempt"

----------------------------------------
----- Variables ------------------------
----------------------------------------
local currentRotation = 0
local currentPosition = Vector3.new(0, 0, 0)
local currentTarget = nil
local offsets = {}
local canPlace = true

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function GridRound(point)
	return Vector3.new(math.floor(point.X + 0.5), point.Y, math.floor(point.Z + 0.5))
end

local function GetRotationCFrame()
	return CFrame.fromAxisAngle(Vector3.new(0, 1, 0), math.rad(currentRotation))
end

local function Rotate()
	preview.PrimaryPart.CFrame = CFrame.new(preview.PrimaryPart.CFrame.p) * GetRotationCFrame()
	for part, offset in pairs(offsets) do
		part.CFrame = preview.PrimaryPart.CFrame:toWorldSpace(offset)
	end
end

local function UpdatePreview()
	if not canPlace or not SharedPlacement.CanPlace(localPlayer, preview, currentTarget, currentPosition) then
		preview.Parent = nil
		return
	else
		preview.Parent = workspace
	end
	
	preview:MoveTo(currentPosition)
end

local function Place()
	if not canPlace then return end
	if not SharedPlacement.CanPlace(localPlayer, preview, currentTarget, currentPosition) then return end
	
	preview.Parent = nil
	canPlace = false
	local success = remotePlaceAttempt:InvokeServer(tool, currentTarget, currentPosition, currentRotation)
	
	if success then
		preview:Destroy()
		tool:Destroy()
	else
		warn("Placement failed!")
		canPlace = true
		UpdatePreview()
	end
end

local function OnEquipped(mouse)
	preview.Parent = workspace
	mouse.TargetFilter = preview
	
	local function CastMouseRay()
		return workspace:FindPartOnRayWithIgnoreList(
			Ray.new(mouse.UnitRay.Origin, mouse.UnitRay.Direction * 100),
			{ localPlayer.Character, preview },
			false, false
		)
	end
	
	local target, hit = CastMouseRay()
	currentTarget = target
	currentPosition = GridRound(hit)
	UpdatePreview()
	
	mouse.Button1Down:connect(function()
		local target, hit = CastMouseRay()
		currentTarget = target
		currentPosition = GridRound(hit)
		UpdatePreview()
		Place()
	end)
	
	mouse.Move:connect(function()
		local target, hit = CastMouseRay()
		currentTarget = target
		currentPosition = GridRound(hit)
		UpdatePreview()
	end)
	
	mouse.KeyDown:connect(function(key)
		if key == 'r' then
			currentRotation = currentRotation + 90
			Rotate()
			UpdatePreview()
		end
	end)
end

local function OnUnequipped()
	preview.Parent = nil
end

----------------------------------------
----- Client Placement -----------------
----------------------------------------
Hierarchy.CallOnDescendants(preview, function(object)
	if object:IsA("LuaSourceContainer") or object:IsA("Light") then
		object:Destroy()
	end
	
	if object:IsA("BasePart") then
		object.Anchored = true
		object.CanCollide = false
		
		if object == preview.PrimaryPart then
			if object.Name == "BOUNDINGBOX" then
				object.Transparency = 1
			end
		else
			offsets[object] = preview.PrimaryPart.CFrame:toObjectSpace(object.CFrame)
			object.Transparency = math.min(object.Transparency + 0.5, 0.75)
		end
	end
end)

tool.Equipped:connect(OnEquipped)
tool.Unequipped:connect(OnUnequipped)