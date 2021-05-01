----------------------------------------
----- Constants ------------------------
----------------------------------------
local NORMAL_JUMP_DELAY = 0.7
local DAMAGED_JUMP_DELAY = 2
local SWIMMING_JUMP_DELAY = 1.5
local DAMAGED_JUMP_COOLDOWN = 5

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local PlayerCharacter = Load "Utility.PlayerCharacter"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local localPlayer = game.Players.LocalPlayer
local humanoid = PlayerCharacter.WaitForCurrentHumanoid(localPlayer)

----------------------------------------
----- Variables ------------------------
----------------------------------------
local lastJump = 0
local lastDamage = 0
local lastHealth = humanoid.Health

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function OnHealthChanged(newHealth)
	local delta = newHealth - lastHealth
	
	if delta < 0 then
		lastDamage = tick()
	end
	
	lastHealth = newHealth
end

local function OnStateChanged(old, new)
	if new ~= Enum.HumanoidStateType.Jumping then return end
	
	local jumpTick = tick()
	lastJump = jumpTick
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
	
	local duration
	local wasHit = tick() - lastDamage < DAMAGED_JUMP_COOLDOWN
	local isSwimming = old == Enum.HumanoidStateType.Swimming
	
	if wasHit and isSwimming then
		duration = math.max(DAMAGED_JUMP_DELAY, SWIMMING_JUMP_DELAY)
	elseif wasHit then
		duration = DAMAGED_JUMP_DELAY
	elseif isSwimming then
		duration = SWIMMING_JUMP_DELAY
	else
		duration = NORMAL_JUMP_DELAY
	end
	
	wait(duration)
	if lastJump == jumpTick then
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
	end
end

----------------------------------------
----- Jump Limiter ---------------------
----------------------------------------
humanoid.HealthChanged:connect(OnHealthChanged)
humanoid.StateChanged:connect(OnStateChanged)