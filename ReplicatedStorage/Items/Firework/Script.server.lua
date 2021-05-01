local Debris = game:GetService("Debris")

local Firework = script.Parent
local Offset = Vector3.new(0,Firework.Size.Y/2 + 1,0)

local ExplosionPart = Instance.new("Part")
ExplosionPart.FormFactor = Enum.FormFactor.Symmetric
ExplosionPart.Shape = Enum.PartType.Ball
ExplosionPart.Size = Vector3.new(1,1,1)
ExplosionPart.Reflectance = .2
ExplosionPart.TopSurface = Enum.SurfaceType.Smooth
ExplosionPart.BottomSurface = Enum.SurfaceType.Smooth

local function Rise(Amount)
	local Offset = Firework.Position
	for i=1, Amount do
		Firework.CFrame = CFrame.new(Offset + Vector3.new(0,i,0))
		wait()
	end
	return Firework.Position
end

local ExplosionType = {
	function() -- Fountain
		for i=1, math.random(50,75) do
			local Part = ExplosionPart:Clone()
			Part.CFrame = CFrame.new(Firework.Position + Offset)
			Part.Velocity = Vector3.new(math.random(-10,10), math.random(25,100), math.random(-10,10))
			Part.BrickColor = BrickColor.Random()
			Part.Parent = workspace
			Debris:AddItem(Part, math.random(2))
			wait(math.random())
		end
	end,
	function() -- Circle
		local Offset = Rise(math.random(40,60))
		Firework:Remove()
		local Parts = {}
		for Rotation = 0, 360 do
			if math.random(10) == 1 then
				local Part = ExplosionPart:Clone()
				Part.Anchored = true
				Part.CFrame = CFrame.new(Firework.Position) * CFrame.Angles(0,Rotation,0)
				Part.BrickColor = BrickColor.Random()
				Part.Parent = workspace
				Debris:AddItem(Part, math.random(3))
				table.insert(Parts, Part)
			end
		end
		for i=1, 100 do
			for _,Part in pairs(Parts) do
				Part.CFrame = Part.CFrame * CFrame.new(math.random(3)/2,math.random()*-.5,0)
			end
			wait()
		end	
	end,
	function() -- Star
		local Offset = Rise(math.random(40,60))
		Firework:Remove()
		local alpha = (2*math.pi)/10
		local Points = {}
		for i=1, 10 do
			table.insert(Points, CFrame.Angles(0, alpha*i,0) * CFrame.new(i%2,0,0))
		end
		
		local Parts = {}
		for i,v in pairs(Points) do
			local Part = ExplosionPart:Clone()
			Part.Anchored = true
			Part.CFrame = CFrame.new(Offset) * v
			Part.BrickColor = BrickColor.Random()
			Part.Parent = workspace
			table.insert(Parts, Part)
		end
		
		for i=1, 30 do
			for Endian,Part in pairs(Parts) do
				Part.CFrame = Part.CFrame * CFrame.new(Endian%2 > 0 and 2 or 1,0,0)
			end
			wait()
		end
		for i,v in pairs(Parts) do v:Destroy() end
	end,
		function() -- Sphere
		local Offset = Rise(math.random(40,60))
		Firework:Remove()
		local Parts = {}
		for RotationX = 0, 360, 10 do
			for RotationY = 0, 360, 10 do
				if math.random(20) == 1 then
					local Part = ExplosionPart:Clone()
					Part.Anchored = true
					Part.CFrame = CFrame.new(Firework.Position) * CFrame.Angles(RotationX,RotationY,0)
					Part.BrickColor = BrickColor.Random()
					Part.Parent = workspace
					Debris:AddItem(Part, math.random(4)/2)
					table.insert(Parts, Part)
				end
			end
		end
		for i=1, 100 do
			for _,Part in pairs(Parts) do
				Part.CFrame = Part.CFrame * CFrame.new(math.random(2)/2,math.random()*-.5,0)
			end
			wait()
		end	
	end
}

local ClickDetector = Firework:FindFirstChild("ClickDetector") or Instance.new("ClickDetector", Firework)
ClickDetector.MouseClick:wait()

Firework.Locked = true
Firework.Anchored = true
ExplosionType[math.random(#ExplosionType)]()
Firework:Remove()
