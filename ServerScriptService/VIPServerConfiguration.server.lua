wait(.1)
local ownerId = game.VIPServerOwnerId
--print("ownerId: "..ownerId)


local StudioMode = (game.CreatorId == 0) or (game:FindService("NetworkServer") == nil)






----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local Create = Load "Create"
local DataAccessor = Load "Data.DataAccessor"

local ChatService = game:GetService("Chat")
local StudioMode = (game.CreatorId == 0) or (game:FindService("NetworkServer") == nil)
----------------------------------------
----- Objects --------------------------
----------------------------------------
local apply = Load "VIPMenu.Apply"
local connec = Load "VIPMenu.Check"
local des = Load "VIPMenu.Destroy"

local config = game.ReplicatedStorage.ConfigValues

local st = config.StatMultiplier
local re = config.RegenMultiplier
local da = config.DayNightMultiplier
local he = config.HealthMultiplier
local gr = config.GrowthMultiplier
----------------------------------------
----- Functions ------------------------
----------------------------------------

apply.OnServerEvent:connect(function (ply,t,n)
	--print("event fired")
	local sd = string.upper(t)
	print("SERVER ACCEPTED SETTING CHANGE: "..sd.." MULTIPLIER ADJUSTED")
	if t == "stats" then
		st.Value = n
	elseif t == "regen" then
		re.Value = n
	elseif t == "daynight" then
		da.Value = n
	elseif t == "health" then
		he.Value = n
	elseif t == "growth" then
		gr.Value = n
	end
end)



local function OnPlayerAdded(player)
	if ownerId == player.UserId then
		connec:FireClient(player)
	--	print "VIP: OWNER"
	else
		des:FireClient(player)
	--	print "NOT VIP"
	end
end


game.Players.PlayerAdded:connect(OnPlayerAdded)
