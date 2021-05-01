local SEA_LEVEL = 25

local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local Class = Load "Utility.Class"
local Signal = Load "Utility.Signal"
local Hierarchy = Load "Utility.Hierarchy"
local Damage = Load "Utility.Damage"

local PathfindingService = game:GetService("PathfindingService")
PathfindingService.EmptyCutoff = 0.06

local AIStates = {
	-- Default idle state.
	Idle = 0;
	-- "wandering" to a point.
	Wandering = 1;
	-- Fleeing from a player.
	Fleeing = 2;
	-- Attacking a player.
	Attacking = 3;
}

local SharedAI = {}
SharedAI.__index = Class.__index
SharedAI.__newindex = SharedAI.__newindex

SharedAI.Dispositions = {
	-- Will flee if attacked.
	Benign = 1;
	-- Will attack if attacked; otherwise will ignore the player.
	Neutral = 2;
	-- Will attack any player within range.
	Hostile = 3;
}

function SharedAI.new(animal)
	local self = setmetatable(Class.new(), SharedAI)
	self.Animal = animal
	self.Backup = animal:Clone()
	self.Humanoid = animal:FindFirstChild("Humanoid")
	self.Speed = self.Humanoid.WalkSpeed
	self.Range = DataAccessor.Get(animal, "Animal.Range")
	self.AttackRange = DataAccessor.Get(animal, "Animal.AttackRange")
	self.Damage = DataAccessor.Get(animal, "Animal.Damage")
	self.LastHealth = self.Humanoid.Health
	self.State = AIStates.Idle
	self.MoveFinished = Signal.new()
	self.LastAttack = tick()
	
	self.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
	self.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
	self.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	self.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
	
	self.Humanoid.MoveToFinished:connect(function(success)
		if self.Moving then
			if success then
				self.PathIndex = self.PathIndex + 1
				
				if self.PathIndex > #self.PathPoints then
					self.Moving = false
					self.MoveFinished:Fire(true)
				else
					local nextPoint = self.PathPoints[self.PathIndex]
					self.CurrentPoint = nextPoint
					self.Humanoid:MoveTo(nextPoint)
				end
			else
				self.Moving = false
				self.MoveFinished:Fire(false)
			end
		end
	end)
	
	
	local HPGUI = Instance.new("BillboardGui", animal:findFirstChild("Head"))
	HPGUI.Size = UDim2.new(3, 0, .5, 0)
	HPGUI.ExtentsOffset = Vector3.new(0, 2, 0)
	local HPFRAME = Instance.new("ImageLabel", HPGUI)
	HPFRAME.Size = UDim2.new(1,0,1,0)
	HPFRAME.BackgroundTransparency = .6
	HPFRAME.Image = "http://www.roblox.com/asset/?id=61542359"
	local HPGREEN = Instance.new("ImageLabel", HPFRAME)
	HPGREEN.Size = UDim2.new(1,0,1,0)
	HPGREEN.BackgroundTransparency = .6
	HPGREEN.Image = "http://www.roblox.com/asset/?id=61542374"


	self.Humanoid.HealthChanged:connect(function(newHealth)
		HPGREEN.Size = UDim2.new(newHealth/self.Humanoid.MaxHealth,0,1,0)
	end)
	
	self.Humanoid.Died:connect(function()
		for _, descendant in ipairs(Hierarchy.GetDescendants(self.Animal)) do
			if descendant:IsA("BasePart") then
				local drop = DataAccessor.Get(descendant, "Animal.Drop")
				local chance = DataAccessor.Get(descendant, "Animal.DropChance") or 1
				
				if drop ~= nil and math.random() < chance then
					local copy = drop:Clone()
					descendant:Destroy()
					copy.Parent = self.Animal
					copy.Anchored = false
					copy.CFrame = descendant.CFrame
					
					DataAccessor.Set(copy, "DenyGather", false)
					DataAccessor.Set(copy, "DenyDrag", false)
				end
			end
		end
		
		wait(15)
		
		local check = DataAccessor.Get(animal, "NORESPAWN")
		
		
		self.Animal:Destroy()
		if check == nil then
			self.Backup.Parent = workspace.Animals
			self.Backup:MoveTo(self.Backup.Torso.Position)
			self.Backup:MakeJoints()
		end
		
		
		--print("Animal "..self.Animal.Name)
		--print("Backup "..self.Backup.Name)
	end)
	
	self.Humanoid.HealthChanged:connect(function(newHealth)
		local delta = newHealth - self.LastHealth
		
		if delta < 0 then
			if self.Disposition == SharedAI.Dispositions.Benign then
				self:Flee()
			elseif self.Disposition == SharedAI.Dispositions.Neutral then
				self:AttackNearest()
			end
		end
	end)
	
	self.Humanoid.Seated:connect(function(active)
		print("SEATED")
		
		if active then
			self.Humanoid.Jump = true
		end
	end)
	
	self.MoveFinished:connect(function(success)
		if not self.Alive then
			return
		end
		
		if self.State == AIStates.Wandering then
			self.State = AIStates.Idle
		elseif self.State == AIStates.Fleeing then
			local nearby = #self:GetNearbyPlayers()
			
			if nearby == 0 then
				self.State = AIStates.Idle
				self.Humanoid.WalkSpeed = self.Speed
			else
				self:Flee()
			end
		end
	end)
	
	return self
end

function SharedAI:Wander()
	local point
	
	for i = 1, 10 do
		local pointX = self.Humanoid.Torso.Position.X + math.random(-self.Range, self.Range)
		local pointZ = self.Humanoid.Torso.Position.Z + math.random(-self.Range, self.Range)
		
		local ray = Ray.new(Vector3.new(pointX, self.Humanoid.Torso.Position.Y + 20, pointZ), Vector3.new(0, -500, 0))
		local part, testPoint = workspace:FindPartOnRayWithIgnoreList(ray, { workspace.Constructables, workspace.Regions, workspace.Animals })
		
		if part and part ~= workspace.Terrain and testPoint.Y <= self.Humanoid.Torso.Position.Y + 5 then
			point = testPoint
			break
		end
	end
	
	if not point then return end
	if self:MovePath(point) then
		if self.Humanoid.Parent.Name == "Testraphyx" then
			print(point)
		end
		self.State = AIStates.Wandering
	end
end

function SharedAI:GetNearbyPlayers()
	local nearby = {}
	
	for _, player in ipairs(game.Players:GetPlayers()) do
		if player.Character and player:DistanceFromCharacter(self.Humanoid.Torso.Position) < self.Range then
			table.insert(nearby, player)
		end
	end
	
	return nearby
end

function SharedAI:GetNearestPlayer()
	local nearby = self:GetNearbyPlayers()
	local nearest = nil
	local nearestDistance = math.huge
	
	for _, player in ipairs(nearby) do
		local distance = player:DistanceFromCharacter(self.Humanoid.Torso.Position)
		
		if distance < nearestDistance then
			nearest = player
			nearestDistance = distance
		end
	end
	
	return nearest
end

function SharedAI:AttackNearest()
	local nearest = self:GetNearestPlayer()
	
	if nearest then
		self:Attack(nearest)
	end
end

function SharedAI:Attack(player)
	self.Target = player
	self.State = AIStates.Attacking
	self:MoveToTarget()
end

function SharedAI:StopAttacking()
	self.Target = nil
	self:StopMoving()
	self.State = AIStates.Idle
end

function SharedAI:Flee()
	self.Humanoid.WalkSpeed = self.Speed * 1.75

	local nearest = self:GetNearestPlayer()
	
	if nearest then
		local movementVector = (nearest.Character.PrimaryPart.Position - self.Humanoid.Torso.Position).unit
		
		if self:MovePath(self.Humanoid.Torso.Position + -movementVector * 2) then
			self.State = AIStates.Fleeing
		end
	end
end

function SharedAI:AutoJump()
	-- Time to jump?
	if self.Moving then
		if not self.Humanoid.Torso then
			print("WTAF")
			return
		end
		
		local origin = self.Humanoid.Torso.Position
		
		if self.Humanoid.LeftLeg ~= nil then
			origin = origin - Vector3.new(0, self.Humanoid.LeftLeg.Size.Y, 0)
		end
		
		local ray = Ray.new(origin, self.Humanoid.Torso.CFrame.lookVector * 4)
		local part, pointOnPart = workspace:FindPartOnRay(ray, self.Animal)
		
		if part then
			local yDist = pointOnPart.Y - part.Position.Y
			local studsAbove = part.Size.Y / 2 - yDist
			
			if studsAbove < self.Animal:GetExtentsSize().Y / 2 then
				self.Humanoid.Jump = true
			end
		end
	end
end

function SharedAI:MovePath(point)
	local path = PathfindingService:ComputeSmoothPathAsync(self.Humanoid.Torso.Position, point, 150)
	
	local points = path:GetPointCoordinates()
	
	for i = 1, #points do
		local terminator = false
		
		if points[i].Y < SEA_LEVEL then
			if self.Humanoid.Parent.Name == "Testraphyx" then
				print(points[i], "below sea level")
			end
			terminator = true
		else
			local ray = Ray.new(points[i], Vector3.new(0, -5, 0))
			local part, point = workspace:FindPartOnRay(ray)
			
			if point.Y < SEA_LEVEL - 2 then
				if self.Humanoid.Parent.Name == "Testraphyx" then
					print(points[i], point, part, "also below sea level")
				end
				terminator = true
			end
		end
		
		if terminator == true then
			for j = #points, i, -1 do
				table.remove(points, j)
			end
			
			break
		end
	end
	
	if #points == 0 then 
		return false
	end
	
	if path.Status ~= Enum.PathStatus.FailStartNotEmpty and path.Status ~= Enum.PathStatus.FailFinishNotEmpty then
		self.Moving = true
		self.PathPoints = points
		self.PathIndex = 1
		self.CurrentPoint = self.PathPoints[1]
		self.Humanoid:MoveTo(self.CurrentPoint)
	else
		self:MoveTo(point)
	end
	
	return true
end

function SharedAI:MoveTo(point)
	self.Moving = true
	self.PathPoints = { point }
	self.PathIndex = 1
	self.CurrentPoint = point
	self.Humanoid:MoveTo(point)
end

function SharedAI:StopMoving()
	if not self.Moving then return end
	self.Moving = false
	self.Humanoid:MoveTo(self.Humanoid.Torso.Position)
end

function SharedAI:MoveToTarget()
	if self.Target == nil or self.Target.Character == nil or self.Target.Character.PrimaryPart == nil then return end
	local distance = (self.Humanoid.Torso.Position - self.Target.Character.PrimaryPart.Position).magnitude
	
	if distance < self.AttackRange / 2 then print("already in range") return end
	self:MovePath(self.Target.Character.PrimaryPart.Position)
end

function SharedAI:Die()
	self.Humanoid.Health = 0
	self.Animal:BreakJoints()
end

function SharedAI:Step(delta)
	if not self.Alive then return end
	-- how the fuck
	if self.Humanoid.Torso == nil then return end
	
	if self.Humanoid.Health < self.Humanoid.MaxHealth then
		self.Humanoid.Health = self.Humanoid.Health + (self.Humanoid.MaxHealth * 0.0125 * delta)
	end
	
	if self.Humanoid.Torso.Position.Y < SEA_LEVEL then
		self.Humanoid:TakeDamage(self.Humanoid.MaxHealth * 0.5 * delta)
	end
	
	if self.State == AIStates.Idle then
		if self.Disposition == SharedAI.Dispositions.Aggressive then
			local nearest = self:GetNearestPlayer()
			
			if nearest then
				self:Attack(nearest)
			else
				self:Wander()
			end
		else
			self:Wander()
		end
	elseif self.State == AIStates.Attacking then
		local nearest = self:GetNearestPlayer()
		
		if nearest then
			if nearest == self.Target then
				if nearest:DistanceFromCharacter(self.Humanoid.Torso.Position) <= self.AttackRange then
					self:StopMoving()
					
					if tick() - self.LastAttack >= 1 then
						Damage(nearest.Character.Humanoid, self.Damage, "Melee")
						self.LastAttack = tick()
					end
				else
					self:MoveToTarget()
				end
			else
				if self.Disposition == SharedAI.Dispositions.Aggressive then
					self:Attack(nearest)
				else
					self:StopAttacking()
				end
			end
		else
			self:StopAttacking()
		end
	end
	
	self:AutoJump()
end

function SharedAI:get_Alive()
	return self.Humanoid.Health > 0
end

return SharedAI