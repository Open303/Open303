----------------------------------------
----- Constants ------------------------
----------------------------------------

local STEP_NIGHT_MODIFIER = 2
local AMBIENT_DAY = Color3.new(0.6, 0.6, 0.6)
local AMBIENT_NIGHT = Color3.new(0.2, 0.2, 0.2)
local MINUTES_IN_DAY = 24 * 60
local HIGH_NOON = 12 * 60

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function GetLinearStep()
	local currentMinutes = game.Lighting:GetMinutesAfterMidnight()
	local distanceFromNoon = math.abs(HIGH_NOON - currentMinutes) * 2
	
	return distanceFromNoon / MINUTES_IN_DAY
end

local function GetAmbient()
	local currentAlpha = GetLinearStep()
	return AMBIENT_DAY:lerp(AMBIENT_NIGHT, currentAlpha)
end

local function Step(_, alpha)
	local STEP_INCREMENT = 2 * game.ReplicatedStorage.ConfigValues.DayNightMultiplier.Value
	local currentTime = game.Lighting:GetMinutesAfterMidnight()
	local stepModifier = GetLinearStep() / STEP_NIGHT_MODIFIER
	local new = currentTime + STEP_INCREMENT * alpha + stepModifier * STEP_INCREMENT * alpha
	game.Lighting:SetMinutesAfterMidnight(new)
	local ambient = GetAmbient()
	game.Lighting.OutdoorAmbient = ambient
end

----------------------------------------
----- Day-Night Cycle ------------------
----------------------------------------
game.Lighting.Ambient = Color3.fromRGB(6, 6, 6)
game:GetService("RunService").Stepped:connect(Step)