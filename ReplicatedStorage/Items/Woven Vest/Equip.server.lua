local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"

local armor = script.Parent

local duplicate = armor:clone()
duplicate:ClearAllChildren()
duplicate.Locked = true
duplicate.CanCollide = false
duplicate.Anchored = false
duplicate.Name = "ACTIVEARMOR"

local function GetTorsoMesh(Character)
	for i,v in pairs(Character:GetChildren()) do
		if v:IsA("CharacterMesh") and v.BodyPart == Enum.BodyPart.Torso then
			return v.MeshId
		end
	end
end

armor.ClickDetector.MouseClick:connect(function(player)
	if player.Character:FindFirstChild("ACTIVEARMOR") then
		return
	else
		duplicate.CFrame = player.Character.Torso.CFrame
		duplicate.Parent = player.Character
		
		local weld = Instance.new("ManualWeld", duplicate)
		weld.Part0 = player.Character.Torso
		weld.Part1 = duplicate
		
		local meshId = GetTorsoMesh(player.Character)
		if meshId then
            local mesh = Instance.new("SpecialMesh", duplicate)
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = ("http://www.roblox.com/asset?id=%s"):format(meshId)
            mesh.Scale = Vector3.new(1.05, 1.05, 1.05)
        else
            Instance.new("BlockMesh", duplicate).Scale = Vector3.new(1.05, 1.05, 1.05)
        end
	
		player.Character.Humanoid.WalkSpeed = DataAccessor.Get(armor, "Speed")	
		
		armor.Data.Parent = duplicate
		armor:Destroy() 
	end
end)