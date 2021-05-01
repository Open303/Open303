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
local constructablesBin = Load "Constructables"
local remotePlaceAttempt = Load "Placement.PlacementAttempt"

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function PlacementAttempt(player, tool, target, point, rotation)
	local source = constructablesBin:FindFirstChild(tool.Name)
	
	if SharedPlacement.CanPlace(player, source, target, point) then
		local object = source:Clone()
		DataAccessor.Set(object, "Owner", player)
		DataAccessor.Set(object, "OwnerString", player.Name)
	--	print("PLACED: "..player.Name.." has placed "..object.Name)
		local originalCFrame = object.PrimaryPart.CFrame
		
		local newCFrame = CFrame.new(point) * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), math.rad(rotation))
		object.PrimaryPart.CFrame = newCFrame
		object.Parent = workspace.Constructables
		object:MoveTo(point)
		
		local properties = {}
		for _, part in ipairs(Hierarchy.GetDescendants(object)) do
			if part:IsA("BasePart") and part ~= object.PrimaryPart then
				local offset = originalCFrame:toObjectSpace(part.CFrame)
				properties[part] = {}
				properties[part].Anchored = part.Anchored
				properties[part].CanCollide = part.CanCollide
				part.Anchored = true
				part.CanCollide = false
				part.CFrame = newCFrame:toWorldSpace(offset)
			end
		end
		
		if object.PrimaryPart.Name == "BOUNDINGBOX" then
			object.PrimaryPart:Destroy()
		end
		
		object:MakeJoints()
		
		Hierarchy.CallOnDescendants(object, function(descendant)
			if descendant:IsA("BasePart") then
				descendant.Anchored = false
				descendant:MakeJoints()
				
				if properties[descendant] then
					descendant.Anchored = properties[descendant].Anchored
					descendant.CanCollide = properties[descendant].CanCollide
				end
			end
		end)
		
		tool:Destroy()
		return true
	end
	
	return false
end

local function OnPlayerRemoving(player)
	local nameval = player.Name
	
	for _, struc in ipairs(workspace.Constructables:GetChildren()) do
		if DataAccessor.Get(struc, "OwnerString") == nameval and DataAccessor.Get(struc, "Owner") == player then
			struc.Data.Owner:destroy()
			local Unclaimed = Instance.new("IntValue", struc.Data)
			Unclaimed.Name = "UNCLAIMED"
		--	print("MARKED: "..struc.Name.." that belongs to "..DataAccessor.Get(struc, "OwnerString").."")
		end
	end
	
	wait(60 * 15)
	
	local returncheck = game.Players:FindFirstChild(nameval)
	if returncheck == nil then
		for _, structure in ipairs(workspace.Constructables:GetChildren()) do
			local stringval2 = DataAccessor.Get(structure, "UNCLAIMED")
			if stringval2 ~= nil then
				if DataAccessor.Get(structure, "OwnerString") == nameval then
			--		print("DESTROYED: "..structure.Name.." that belongs to "..DataAccessor.Get(structure, "OwnerString").."")
					structure:Destroy()
				end
			end			
		end
	end
end

local function onPlayerAdded(player)
	for _, structures in ipairs(workspace.Constructables:GetChildren()) do
		local strVal = DataAccessor.Get(structures, "UNCLAIMED")
		if strVal ~= nil then
			if DataAccessor.Get(structures, "OwnerString") == player.Name then
				DataAccessor.Set(structures, "Owner", player)
				structures.Data.UNCLAIMED:destroy()
		--		print("RECLAIMED: "..structures.Name.." that belongs to "..DataAccessor.Get(structures, "OwnerString").."")
			end
		end
	end
	
end
----------------------------------------
----- Server Placement -----------------
----------------------------------------
remotePlaceAttempt.OnServerInvoke = PlacementAttempt
game.Players.PlayerRemoving:connect(OnPlayerRemoving)
game.Players.PlayerAdded:connect(onPlayerAdded)