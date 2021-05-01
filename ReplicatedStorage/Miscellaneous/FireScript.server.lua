-- Split to stop FireStarter lagging server

----------------------------------------
----- Constants ------------------------
----------------------------------------
local DPS = 10

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local PlayerCharacter = Load "Utility.PlayerCharacter"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local fireScript = Load "Miscellaneous.FireScript"

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function HeatPart(part)
	local result = DataAccessor.Get(part, "HeatsTo")
	
	if result then
		local clone = result:Clone()
		
		clone.CFrame = part.CFrame
		clone.Parent = part.Parent
		part:Destroy()
		clone:MakeJoints()
	end
end

local function BurnPart(part)
	local copy = fireScript:Clone()
	copy.Parent = part
	copy.Disabled = false
end

----------------------------------------
----- Fire Module ----------------------
----------------------------------------
function Fire(burningPart)
	local burnDuration = DataAccessor.Get(burningPart, "BurnTime") or burningPart:GetMass() / 1.9
	local maxBounds = math.max(burningPart.Size.X, burningPart.Size.Y, burningPart.Size.Z)
	local offsetSize = Vector3.new(maxBounds, maxBounds, maxBounds) / 2
	
	local function SpreadFire()
		local region = Region3.new(burningPart.Position - offsetSize, burningPart.Position + offsetSize)
		local parts = workspace:FindPartsInRegion3(region, burningPart, 100)
		
		for _, part in ipairs(parts) do
			if DataAccessor.Get(part, "HeatsTo") ~= nil then
				HeatPart(part)
			elseif DataAccessor.Get(part, "Flammable") and not DataAccessor.Get(part, "OnFire") then
				BurnPart(part)
			end
		end
	end
	
	DataAccessor.Set(burningPart, "OnFire", true)
	DataAccessor.Set(burningPart, "OriginalColor", burningPart.BrickColor)
	
	burningPart.BrickColor = BrickColor.new("Bright red")
	
	local light = Instance.new("PointLight", burningPart)
	light.Name = "BurningLightEffect"
	light.Color = Color3.new(1, 0, 0)
	light.Range = maxBounds * 2.5
	light.Brightness = 2.5
	light.Shadows = true
	
	local fire = Instance.new("Fire", burningPart)
	fire.Name = "BurningFireEffect"
	fire.Color = Color3.new(1, 0.5, 0)
	fire.Heat = 10
	fire.SecondaryColor = Color3.new(1, 0, 0)
	fire.Size = math.max(burningPart.Size.X, burningPart.Size.Z) * 1.5
	
	if DataAccessor.Get(burningPart, "ExplosivePower") ~= nil then
		SpreadFire()
		local explosion = Instance.new("Explosion")
		explosion.ExplosionType = Enum.ExplosionType.NoCraters
		explosion.BlastRadius = DataAccessor.Get(burningPart, "ExplosivePower")
		explosion.Position = burningPart.Position
		explosion.Parent = workspace
		
		burningPart:Destroy()
	else
		while burnDuration > 0 do
			local delta = wait(1)
			
			if math.random(1, 10) == 1 then
				SpreadFire()
			end
			
			local touchingParts = burningPart:GetTouchingParts()
			local humanoids = {}
			
			for _, touchingPart in ipairs(touchingParts) do
				local humanoid = PlayerCharacter.GetHumanoidFromPart(touchingPart)
				
				if humanoid ~= nil then
					humanoids[humanoid] = true
				end
			end
			
			for humanoid in pairs(humanoids) do
				humanoid:TakeDamage(DPS * delta)
			end
			
			burnDuration = burnDuration - 1
		end
		
		burningPart:Destroy()
	end
end

Fire(script.Parent)