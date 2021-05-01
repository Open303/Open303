-- Player management commands:
-- Kick, ban, server ban, etc.

local Load = require(game:GetService("ReplicatedStorage"):WaitForChild("Load"))
local RankChecker = Load "Commands.RankChecker"
local PlayerMatcher = Load "Commands.PlayerMatcher"
local CommandAdder = Load "Commands.CommandAdder"

local ChatSettings = Load("ClientChatModules.ChatSettings", game:GetService("Chat"))

local errorExtraData = {ChatColor = ChatSettings.ErrorMessageTextColor or Color3.fromRGB(245, 50, 50)}
local successExtraData = {ChatColor = ChatSettings.AdminSuccessTextColor}

local banStore = game:GetService("DataStoreService"):GetDataStore("BansV2")

local function Run(ChatService, Logs)
	local banned = {}
	
	local function Ban(player, reason, sender)
		banned[player.UserId] = reason
		player:Kick("You have been banned by "..sender.Name.." for "..reason)
	end
	
	local function GlobalBan(player, reason, sender)
		pcall(banStore.SetAsync, banStore, player.UserId, reason)
		Ban(player, reason, sender)
	end
	
	local function GetBanInfo(player)
		local cachedBan = banned[player.UserId]
		
		if cachedBan then
			return true, cachedBan
		end
		
		local success, reason = pcall(banStore.GetAsync, banStore, player.UserId)
		if success and reason then
			banned[player.UserId] = reason
		end
	end
	
	local function HandleKick(channelName, speaker, parts)
		local sender = speaker:GetPlayer()
		local targets = PlayerMatcher.Match(sender, parts[1], false)
		local kickedNames = {}
		local reason = parts[2] or "<unspecified>"
		
		for _, target in ipairs(targets) do
			if not RankChecker.IsStaff(target) then
				target:Kick(reason)
				table.insert(kickedNames, target.Name)
			end
		end
		
		if #kickedNames == 0 then
			speaker:SendSystemMessage("No players were kicked.", channelName, errorExtraData)
		else
			Logs.PublicLog:SendSystemMessage(("%s kicked %s"):format(sender.Name, table.concat(kickedNames, ", ")), successExtraData)
		end
	end
	
	local function HandleBan(channelName, speaker, parts)
		local sender = speaker:GetPlayer()
		local targets = PlayerMatcher.Match(sender, parts[1], false)
		local kickedNames = {}
		local reason = parts[2] or "<unspecified>"
		
		for _, target in ipairs(targets) do
			if not RankChecker.IsStaff(target) then
				target:Kick(reason)
				table.insert(kickedNames, target.Name)
			end
		end
		
		if #kickedNames == 0 then
			speaker:SendSystemMessage("No players were banned.", channelName, errorExtraData)
		else
			Logs.PublicLog:SendSystemMessage(("%s kicked %s"):format(sender.Name, table.concat(kickedNames, ", ")), successExtraData)
		end
	end
	
	local function HandleGlobalBan(channel, speaker, parts)
		local sender = speaker:GetPlayer()
		local targets = PlayerMatcher.Match(sender, parts[1], false)
		local kickedNames = {}
		local reason = parts[2] or "Globally banned by "..sender.Name
		
		for _, target in ipairs(targets) do
			if not RankChecker.IsStaff(target) then
				target:Kick(reason)
				table.insert(kickedNames, target.Name)
			end
		end
		
		if #kickedNames == 0 then
			speaker:SendSystemMessage("No players were banned.", channel, errorExtraData)
		else
			speaker:SendSystemMessage(("%s globally banned %s."):format(table.concat(kickedNames, ", ")), channel, successExtraData)
		end
	end
	
	CommandAdder.AddCommand(ChatService, {
		Name = "kick";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = HandleKick;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "gban";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = HandleGlobalBan;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "ban";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = HandleBan;
	})
end

return Run