local ACTIVATOR = script.Parent

local DUPLICATE = ACTIVATOR:clone();
DUPLICATE:ClearAllChildren();
DUPLICATE.Locked = true;
DUPLICATE.CanCollide = false;
DUPLICATE.Anchored = false
Instance.new("BlockMesh", DUPLICATE).Scale = Vector3.new(1.05, 1.05, 1.05)
DUPLICATE.Name = "ACTIVEQUIVER"

ACTIVATOR.ClickDetector.mouseClick:connect(function(player)
	if player.Character:FindFirstChild("ACTIVEQUIVER") then
		return
	
	else
	
		DUPLICATE.CFrame = player.Character["Left Arm"].CFrame
		DUPLICATE.Parent = player.Character
		
		local Weld = Instance.new("ManualWeld", DUPLICATE)
		Weld.Part0 = player.Character["Left Arm"]
		Weld.Part1 = DUPLICATE	
		Weld.C0 = CFrame.new(.4, .4, .4)
		
		ACTIVATOR.Data.Parent = DUPLICATE
		ACTIVATOR:destroy()
	
	end
end)