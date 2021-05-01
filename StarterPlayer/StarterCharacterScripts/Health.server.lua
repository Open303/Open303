----------------------------------------
----- Constants ------------------------
----------------------------------------
-- The stat that affects health.
local AFFECTING_STAT = "Vitality"
-- Factor to multiply the raw value by. Larger values = more extreme regen / damage.
local FACTOR = 1.5
-- Delay in seconds between steps.
local STEP_DELAY = 1

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local SharedStats = Load "Stats.SharedStats"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local character = script.Parent
local player = game.Players:GetPlayerFromCharacter(character)
local humanoid = character:WaitForChild("Humanoid")

----------------------------------------
----- Variables ------------------------
----------------------------------------
local lastHealthStep = tick()

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function Step()
	local currentTick = tick()
	local delta = currentTick - lastHealthStep
	
	local value = SharedStats.Get(player, AFFECTING_STAT)
	local change = (math.floor(value) / 100) * FACTOR * delta
	
	humanoid.Health = humanoid.Health + change
	lastHealthStep = currentTick
	
	if game.VIPServerId ~= "" then
		humanoid.MaxHealth = (game.ReplicatedStorage.ConfigValues.HealthMultiplier.Value * 100)
	end
end

----------------------------------------
----- Health ---------------------------
----------------------------------------
while true do
	wait(STEP_DELAY)
	Step()
end