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
local remoteCNTAttempt = Load "TribesMenu.CNTAttempt"
local remoteLTAttempt = Load "TribesMenu.LTAttempt"
local remoteIMAttempt = Load "TribesMenu.IMAttempt"
local remoteIMReturn = Load "TribesMenu.IMReturn"
local remoteTIAttempt = Load "TribesMenu.TIAttempt"
local remoteFBReturn = Load "TribesMenu.FBReturn"
local remoteFNAttempt = Load "TribesMenu.FNAttempt"
local remoteUIReturn = Load "TribesMenu.UIReturn"

----------------------------------------
----- Functions ------------------------
----------------------------------------

remoteCNTAttempt.OnServerEvent:connect(function (ply,tribename,color)
	
	local filteredname = tribename
	
	--print("NEWTRIBE UNFILTERED: "..tribename)	
	
	if not StudioMode then
		filteredname = game.Chat:FilterStringForBroadcast(tribename, ply)
    end
	
	--print("NEWTRIBE FILTERED: "..filteredname)	
	
	wait(1)
	
	local symbolcheck = filteredname:match("%p")
	local backupcheck = filteredname:match("[#]")

if symbolcheck ~= nil or filteredname ~= tribename or backupcheck ~= nil then
		--print("fail check")
		local message = "That name is inappropriate."
		remoteFBReturn:FireClient(ply, message)		
	else
		--print("pass check")
		wait(0.1)
		--backup check zone to account for server-client delay
		local ISSUE = game.Teams:FindFirstChild(filteredname)
		local CURRTRIBES = game.Teams:GetChildren()
		local colorrunner = BrickColor.new(color)
		local truefalse = false
		
		for index, team in pairs(CURRTRIBES) do
			if team.TeamColor == colorrunner then
				truefalse = true
			end						
		end		
		
		if ISSUE == nil and truefalse == false then
			local newtribe = Instance.new("Team", game.Teams)
			newtribe.Name = filteredname
			newtribe.AutoAssignable = false
			newtribe.TeamColor = BrickColor.new(color)
		
			local ticker = Instance.new("IntValue", newtribe)
			ticker.Value = 1
			ticker.Name = "Members"
			
			ply.Neutral = false
			ply.TeamColor = newtribe.TeamColor
			local appmes = "You've created a new tribe!"
			remoteFBReturn:FireClient(ply, appmes)
			remoteUIReturn:FireClient(ply, filteredname, color)
		else
			print("WARNING: overinput. Failsafe activated.")
		end
	end
end)

remoteLTAttempt.OnServerEvent:connect(function (ply)
	
	local currentribe = ply.Team.Name	
	local playerstribe = game.Teams:FindFirstChild(currentribe)
	local tickeraba = playerstribe.Members	
	
	tickeraba.Value = tickeraba.Value - 1
	
	if tickeraba.Value < 1 then
		playerstribe:Destroy()
	end
	
	ply.Neutral = true
	local returnmsg = "You've left your old tribe!"
	remoteFBReturn:FireClient(ply, returnmsg)
	
end)

remoteIMAttempt.OnServerEvent:connect(function (ply,recipient,newcolor,newtribe)
	local toplayer = game.Players:FindFirstChild(recipient)
	local sender = ply.Name
	
	if toplayer.TeamColor ~= newcolor then
		remoteIMReturn:FireClient(toplayer, sender, newcolor, newtribe)
	else
		if toplayer.Neutral == true then
			remoteIMReturn:FireClient(toplayer, sender, newcolor, newtribe)
		end	
	end
end)

remoteTIAttempt.OnServerEvent:connect(function (ply,tribename)
	local joinedtribe = game.Teams:FindFirstChild(""..tribename.."")
	local memberticker = joinedtribe.Members
	local teamcolornew = joinedtribe.TeamColor
		
	memberticker.Value = memberticker.Value + 1
	
	if ply.Neutral == false then
		local savedtribe = ply.Team
		
		savedtribe.Members.Value = savedtribe.Members.Value - 1
		
		if savedtribe.Members.Value < 1 then
			savedtribe:destroy()
		end
	end
	
	ply.Neutral = false
	ply.TeamColor = teamcolornew
		
end)

remoteFNAttempt.OnServerEvent:connect(function(ply,sendto, inform)
	local reciever = game.Players:FindFirstChild(sendto)
	
	remoteFBReturn:FireClient(reciever, inform)
end)

game.Players.PlayerRemoving:connect(function(player)
	local lplayersteam = player.Team
	if lplayersteam ~= nil then
		local membertickerleave = lplayersteam.Members
		membertickerleave.Value = membertickerleave.Value - 1
	
		if membertickerleave.Value < 1 then
			lplayersteam:Destroy()
		end
	end
end)
