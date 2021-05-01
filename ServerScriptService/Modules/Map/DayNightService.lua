local MINUTES_IN_DAY = 24 * 60
local HIGH_NOON = 12 * 60

local Lighting = game:GetService("Lighting")

local DayNightService = {}

DayNightService.AmbientDay = Color3.new(0.6, 0.6, 0.6)
DayNightService.AmbientNight = Color3.new(0.15, 0.15, 0.15)
DayNightService.LightingTimeFactor = 2.5

local function GetLinearAlpha(currentTime)
	local distanceFromNoon = math.abs(HIGH_NOON - currentTime) * 2
	return distanceFromNoon / MINUTES_IN_DAY
end

function DayNightService:Step(alpha)
	local currentTime = Lighting:GetMinutesAfterMidnight()
	local linearAlpha = GetLinearAlpha(currentTime)
	local timeChange = DayNightService.LightingTimeFactor * alpha
	local newTime = currentTime + timeChange
	Lighting:SetMinutesAfterMidnight(newTime)
	Lighting.OutdoorAmbient = DayNightService.AmbientDay:lerp(DayNightService.AmbientNight, linearAlpha)
end

game.Lighting.Ambient = Color3.new(0, 0, 0)

return DayNightService
