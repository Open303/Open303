----------------------------------------
----- Constants ------------------------
----------------------------------------
local STAT_STEP_INTERVAL = 1
local SEA_LEVEL = 25
local DROWN_TIME = 20

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local StatDefinitions = Load "Stats.Definitions"
local SharedStats = Load "Stats.SharedStats"

----------------------------------------
----- Variables ------------------------
----------------------------------------
local lastStatStep = tick()
local firstSpawns = {}

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function StepStats()
	local currentTick = tick()
	local delta = currentTick - lastStatStep
	local statMultiplier = DataAccessor.Get(game:GetService("ReplicatedStorage"), "ConfigValues.StatMultiplier") or 1
	
	for _, player in ipairs(game.Players:GetPlayers()) do
		local statSnapshots = {}
		
		local statsFrozen = DataAccessor.Get(player, "Stats.StatsFrozen")
		local secondsUnderwater = DataAccessor.Get(player, "Stats.SecondsUnderwater") or 0
		
		if not statsFrozen then
			if player.Character ~= nil and player.Character.PrimaryPart ~= nil and player.Character.PrimaryPart.Position.Y < SEA_LEVEL then
				if secondsUnderwater >= DROWN_TIME then
					SharedStats.Increment(player, "Vitality", -3.5 * delta)
				else
					DataAccessor.Set(player, "Stats.SecondsUnderwater", secondsUnderwater + delta)
				end
			else
				DataAccessor.Set(player, "Stats.SecondsUnderwater", math.max(0, secondsUnderwater - delta * 1.5))
			end
			
			if SharedStats.ShouldKillPlayer(player) and player.Character ~= nil then
				player.Character:BreakJoints()
			else
				for statName, definition in pairs(StatDefinitions) do
					statSnapshots[statName] = SharedStats.Get(player, statName)
					if statSnapshots[statName] == nil then
						SharedStats.ResetStats(player, firstSpawns[player])
						statSnapshots[statName] = SharedStats.Get(player, statName)
					end
				end
				
				for statName, definition in pairs(StatDefinitions) do
					local newValue = definition.Step(statSnapshots, delta)
					SharedStats.Set(player, statName, newValue * statMultiplier)
				end
			end
		end
	end
	
	lastStatStep = currentTick
end

local function OnCharacterAdded(player)
	return function(character)
		DataAccessor.Set(player, "Stats.SecondsUnderwater", 0)
		SharedStats.ResetStats(player, firstSpawns[player])
		
		if firstSpawns[player] then
			firstSpawns[player] = false
		end
	end
end

local function OnPlayerAdded(player)
	local characterAdded = OnCharacterAdded(player)
	
	firstSpawns[player] = true
	
	if player.Character then
		characterAdded(player.Character)
	end
	
	player.CharacterAdded:connect(characterAdded)
end

----------------------------------------
----- Server Stats ---------------------
----------------------------------------
for _, player in ipairs(game.Players:GetPlayers()) do
	OnPlayerAdded(player)
end

game.Players.PlayerAdded:connect(OnPlayerAdded)

while true do
	wait(STAT_STEP_INTERVAL)
	StepStats()
end