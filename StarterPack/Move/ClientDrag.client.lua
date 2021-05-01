----------------------------------------
----- Constants ------------------------
----------------------------------------
local TOUCH_DEFAULT_HINT = "Tap an object to start moving it"
local TOUCH_DRAGGING_HINT = "Tap the object to deselect; tap elsewhere to move."
local DRAG_CURSOR_HOVER = "rbxasset://textures/advCursor-openedHand.png"
local DRAG_CURSOR_GRABBED = "rbxgameasset://Images/DragTool-Cursor"

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local Create = Load "Create"
local SharedDrag = Load "StarterTools.Drag.SharedDrag"
local Scaffold = Load "UI.Scaffolder"
local DragGuiScaffold = Load "StarterTools.Drag.DragGuiScaffold"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = game.Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local tool = script.Parent

local remoteDragStart = Load "StarterTools.Drag.DragStart"
local remoteDragUpdate = Load "StarterTools.Drag.DragUpdate"
local remoteDragEnd = Load "StarterTools.Drag.DragEnd"

local dragGui = Instance.new("ScreenGui", playerGui)
dragGui.Name = "DragGui"
local dragContainer = Scaffold(DragGuiScaffold)
dragContainer.Parent = dragGui

local selectionBox = Create "SelectionBox" {
	Name = "DraggerSelection";
	Parent = playerGui;
	Color3 = Color3.fromRGB(128, 192, 255);
	LineThickness = 0.05;
	Visible = false;
}

local dragger = Instance.new("Dragger")

----------------------------------------
----- Variables ------------------------
----------------------------------------
local dragging = false
local wasAnchored = false
local dragPart = nil
local dragPoint = nil
local dragRotators = {}

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function AxisRotate(axis)
	if not dragging then return end
	
	dragger:AxisRotate(axis)
	remoteDragUpdate:FireServer(dragPart.CFrame, dragPart.CFrame.p + dragPart.CFrame:pointToObjectSpace(dragPoint))
end

local function BindAxisRotate(axis)
	return function(input)
		if input.UserInputType == Enum.UserInputType.Touch and input.UserInputState == Enum.UserInputState.Begin then
			AxisRotate(axis)
		end
	end
end

local function StartDrag(part, pointOnPart)
	if dragging or not SharedDrag.CanPlayerDrag(localPlayer, part) then
		return
	end
	
	dragging = true
	dragPart = part
	dragPoint = pointOnPart
	wasAnchored = part.Anchored
	part.Anchored = true
	
	dragPart:BreakJoints()
	
	selectionBox.Adornee = part
	selectionBox.Visible = true
	
	dragger:MouseDown(part, part.CFrame:pointToObjectSpace(pointOnPart), { part })
	remoteDragStart:FireServer(part, pointOnPart)
end

local function StopDrag()
	if not dragging then return end
	
	dragger:MouseUp()
	dragging = false
	dragPart.Anchored = wasAnchored
	dragPart:MakeJoints()
	dragPart = nil
	dragPoint = nil
	
	selectionBox.Adornee = nil
	selectionBox.Visible = false
	
	remoteDragEnd:FireServer()
end

local function UpdateDrag(mouseRay)
	if not dragging then return end
	
	if not SharedDrag.CanPlayerDrag(localPlayer, dragPart) then
		StopDrag()
		return
	end
	
	local last = dragPart.CFrame
	
	dragger:MouseMove(mouseRay)
	
	local translated = dragPart.CFrame.p + dragPart.CFrame:pointToObjectSpace(dragPoint)
	if not SharedDrag.CanDragToPoint(localPlayer, dragPart, translated) then
		dragPart.CFrame = last
	else
		remoteDragUpdate:FireServer(dragPart.CFrame, translated)
	end
end

local function OnEquipped(mouse)
	dragContainer.Visible = true
	
	local function UpdateCursor()
		if dragging then
			mouse.Icon = DRAG_CURSOR_GRABBED
		elseif mouse.Target ~= nil and SharedDrag.CanPlayerDrag(localPlayer, mouse.Target) then
			mouse.Icon = DRAG_CURSOR_HOVER
		else
			mouse.Icon = ""
		end
	end
	
	UpdateCursor()
	
	mouse.Button1Down:connect(function()
		local canSelect = true
		
		-- If touch, we need to deselect if we're already dragging.
		if UserInputService.TouchEnabled then
			if dragging then
				-- If we tap the part, stop the drag
				if mouse.Target == dragPart then
					StopDrag()
					-- Make sure we don't just select the part we just deselected
					canSelect = false
				-- Otherwise, move it to the point the player tapped.
				else
					UpdateDrag(mouse.UnitRay)
				end
			end
		end
		
		if not dragging and canSelect then
			if mouse.Target and SharedDrag.CanPlayerDrag(localPlayer, mouse.Target) then
				StartDrag(mouse.Target, mouse.Hit.p)
			end
		end
		
		UpdateCursor()
	end)
	
	mouse.Move:connect(function()
		if dragging then
			UpdateDrag(mouse.UnitRay)
		end
		
		UpdateCursor()
	end)
	
	mouse.Button1Up:connect(function()
		-- Only deselect on release if we aren't in touch mode.
		if not UserInputService.TouchEnabled then
			StopDrag()
		end
		
		UpdateCursor()
	end)
	
	mouse.KeyDown:connect(function(key)
		if dragging then
			if key == 'r' then
				AxisRotate(Enum.Axis.Z)
				UpdateDrag(mouse.UnitRay)
			elseif key == 't' then
				AxisRotate(Enum.Axis.Y)
				UpdateDrag(mouse.UnitRay)
			end
		end
	end)
end

local function OnUnequipped(mouse)
	StopDrag()
	dragContainer.Visible = false
end

----------------------------------------
----- Client Drag ----------------------
----------------------------------------
dragGui.Parent = playerGui
dragContainer.Visible = false

tool.Equipped:connect(OnEquipped)
tool.Unequipped:connect(OnUnequipped)

while true do
	local character = localPlayer.Character
	if character ~= nil and character:IsDescendantOf(workspace) then
		break
	else
		wait(0)
	end
end

local humanoid = localPlayer.Character:WaitForChild("Humanoid")

humanoid.Died:connect(function()
	dragGui:Destroy()
	StopDrag()
end)