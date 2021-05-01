local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"

local clickDetector = script.Parent.ClickDetector
local bomb = script.Parent

clickDetector.MouseClick:connect(function()
	if bomb.Name == "BACKPACK_EXAMPLE" then return end
	bomb.Locked = true
	bomb.BrickColor = BrickColor.new("Really red")
	clickDetector:Destroy()
	wait(6)

	local boom = Instance.new("Explosion", workspace)
	boom.ExplosionType = Enum.ExplosionType.NoCraters
	boom.Position = bomb.Position
	boom.BlastRadius = DataAccessor.Get(bomb, "ExplosivePower")
	boom.Parent = workspace

	
	local sound = Instance.new("Sound", bomb)
	sound.SoundId = "rbxasset://sounds\\Rocket shot.wav"
	sound.Volume = 1
	sound:Play()
	
	-- vanish the part
	bomb.Anchored = true
	bomb.CanCollide = false
	bomb.Transparency = 1
	wait(0.5)
	bomb:Destroy()
end)
