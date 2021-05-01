local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local SharedFireStarter = Load "Tools.FireStarter.SharedFireStarter"
local PlayerCharacter = Load "Utility.PlayerCharacter"

local fireScript = Load "Miscellaneous.FireScript"
local remoteFireStartAttempt = Load "Tools.FireStarter.FireStartAttempt"
local Burn = Load "Miscellaneous.FireModule"

local function OnFireStartAttempt(player, part, pointOnPart)
	local tool = PlayerCharacter.GetEquippedTool(player)
	
	if tool == nil or DataAccessor.Get(tool, "Tool.Class") ~= "FireStarter" then
		return
	end
	
	local chance = DataAccessor.Get(tool, "Tool.IgnitionChance")
	
	if SharedFireStarter.CanIgnite(player, part, pointOnPart) and math.random() <= chance then
		local copy = fireScript:Clone()
		copy.Parent = part
		-- TODO: fix, massive performance problems
		copy.Disabled = false
	end
end

remoteFireStartAttempt.OnServerEvent:connect(OnFireStartAttempt)