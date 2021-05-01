----------------------------------------
----- Constants ------------------------
----------------------------------------
local STAT_PREFIX = "Stats."

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local StatDefinitions = Load "Stats.Definitions"

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function Clamp(num, min, max)
	return math.max(min, math.min(max, num))
end

local function StatExists(name)
	return StatDefinitions[name] ~= nil
end

local function GetDefinition(name)
	return StatDefinitions[name]
end

----------------------------------------
----- Shared Stats ---------------------
----------------------------------------
local SharedStats = {}

function SharedStats.ResetStats(player, firstSpawn)
	for statName, definition in pairs(StatDefinitions) do
		local currentValue = SharedStats.Get(player, statName)
		local newValue = definition.StartingValue
		
		if not firstSpawn and definition.ResetValue ~= nil then
			newValue = definition.ResetValue
		end
		
		SharedStats.Set(player, statName, newValue)
	end
end

function SharedStats.GetStatObject(player, name)
	return DataAccessor.GetStoringObject(player, STAT_PREFIX..name)
end

function SharedStats.Get(player, name)
	assert(StatExists(name), name.." is not a valid stat name")
	return DataAccessor.Get(player, STAT_PREFIX..name)
end

function SharedStats.Set(player, name, value)
	assert(StatExists(name), name.." is not a valid stat name")
	local definition = GetDefinition(name)
	DataAccessor.Set(player, STAT_PREFIX..name, Clamp(value, definition.MinValue, definition.MaxValue))
end

function SharedStats.Increment(player, name, delta)
	assert(StatExists(name), name.." is not a valid stat name")
	local current = SharedStats.Get(player, name)
	SharedStats.Set(player, name, current + delta)
end

function SharedStats.HasDepletedStat(player)
	for statName, definition in pairs(StatDefinitions) do
		local statValue = SharedStats.Get(player, statName)
		
		if statValue == nil then
			warn(("Stat %s is nil for %s"):format(statName, player.Name))
		elseif statValue <= definition.MinValue then
			return true
		end
	end
	
	return false
end

function SharedStats.ShouldKillPlayer(player)
	for statName, definition in pairs(StatDefinitions) do
		local statValue = SharedStats.Get(player, statName)
		
		if statValue == nil then
			warn(("Stat %s is nil for %s"):format(statName, player.Name))
		elseif SharedStats.Get(player, statName) <= definition.MinValue and not definition.NonCritical then
			return true
		end
	end
	
	return false
end

return SharedStats
