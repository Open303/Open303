local Players = game:GetService("Players")

local import = require(game:GetService("ReplicatedStorage"):WaitForChild("Import"))
local RankChecker = import "~/Commands/RankChecker"
local PlayerMatcher = import "~/Commands/PlayerMatcher"
local CommandAdder = import "~/Commands/CommandAdder"
local PlayerCharacter = import "~/Utility/PlayerCharacter"
local Hierarchy = import "~/Utility/Hierarchy"
local String = import "~/Utility/String"
local Environment = import "~/Environment"

local ChatSettings = import("ClientChatModules/ChatSettings", game:GetService("Chat"))

local errorExtraData = {ChatColor = ChatSettings.ErrorMessageTextColor or Color3.fromRGB(245, 50, 50)}
local successExtraData = {ChatColor = ChatSettings.AdminSuccessTextColor}

local MAX_TEMPBAN_TIME = 60 * 60 * 24 * 30 * 6
local MONTHS = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }

local function GetBanMessage(banData)
	local bannedForever = banData.Duration == -1
	local banReason = banData.Reason
	local banTime
	
	if bannedForever then
		banTime = "forever"
	else
		local banExpiration = banData.Time + banData.Duration
		local info = os.date("*t", banExpiration)
		local month = MONTHS[info.month]
		
		local hourString, amPmString do
			if info.hour > 12 then
				hourString = String.PadLeft(tostring(info.hour - 12), 2, '0')
				amPmString = "PM"
			else
				hourString = String.PadLeft(tostring(info.hour), 2, '0')
				amPmString = "AM"
			end
		end
		
		local format = "until %s %d %d at %s:%s %s"
		banTime = format:format(month, info.day, info.year, hourString, String.PadLeft(tostring(info.min), 2, '0'), amPmString)
	end
	
	local success, username = pcall(Players.GetNameFromUserIdAsync, Players, banData.From)
	if banReason then
		return ("Banned by %s for '%s' %s"):format(success and username or tostring(banData.From), banReason, banTime)
	else
		return ("Banned by %s %s"):format(success and username or tostring(banData.From), banTime)
	end
end

local function TimeStringToSeconds(timeString)
	local hours = tonumber(timeString:match("(%d+)h")) or 0
	local days = tonumber(timeString:match("(%d+)d")) or 0
	local months = tonumber(timeString:match("(%d+)m")) or 0
	return (hours * 60 * 60) + (days * 24 * 60 * 60) + (months * 30 * 24 * 60 * 60)
end

local function Run(ChatService, Logs)
	local banStore = game:GetService("DataStoreService"):GetDataStore("BansV3")
	
	local function GetBanData(player)
		if Environment.ProductionServer then
			local success, banData = false, nil
			while not success do
				success, banData = pcall(banStore.GetAsync, banStore, player.UserId)
			end
			
			return banData
		end
	end
	
	local function Ban(player, banner, reason, duration)
		local banData = {
			Reason = reason;
			Duration = duration or -1;
			Time = os.time();
			From = banner.UserId;
		}
		
		if Environment.ProductionServer then
			banStore:SetAsync(player.UserId, banData)
		end
		
		player:Kick(GetBanMessage(banData))
	end
	
	local function HasBanExpired(banData)
		if banData.Duration == -1 then
			return false
		end
		
		return os.time() > banData.Time + banData.Duration
	end
	
	CommandAdder.AddCommand(ChatService, {
		Name = "kick";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			local usage = "/kick <player>[ <reason>]"
			local reason
			
			if #parts < 1 then
				speaker:SendSystemMessage(usage, channelName, errorExtraData)
			else
				if #parts > 1 then
					reason = table.concat(parts, " ", 2)
				end
				
				local target = PlayerMatcher.MatchSinglePlayer(parts[1])
				
				if target then
					if not RankChecker.IsStaff(target) then
						local kickMessage = "Kicked by "..speaker.Name
						local logMessage = target.Name.." was kicked by "..speaker.Name
						
						if reason then
							kickMessage = kickMessage..": "..reason
							logMessage = logMessage..": "..reason
						end
						
						target:Kick(kickMessage)
						Logs.PublicLog:SendSystemMessage(logMessage, successExtraData)
						Logs.StaffLog:SendSystemMessage(logMessage)
					else
						speaker:SendSystemMessage(("Cannot kick %s because they are a staff member."):format(target.Name), channelName, errorExtraData)
					end
				else
					speaker:SendSystemMessage("Could not find a single player whose name starts with '"..parts[1].."'.", channelName, errorExtraData)
				end
			end
		end;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "tempban";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			local usage = "/tempban <player> <duration> <reason>"
			local duration = parts[2] and TimeStringToSeconds(parts[2])
			
			if #parts < 3 or not duration or duration <= 0 then
				speaker:SendSystemMessage(usage, channelName, errorExtraData)
			elseif duration > MAX_TEMPBAN_TIME then
				speaker:SendSystemMessage("Temporary ban time is too long.", channelName, errorExtraData)
			else
				local reason = table.concat(parts, " ", 3)
				local target = PlayerMatcher.MatchSinglePlayer(parts[1])
				
				if target then
					if not RankChecker.IsStaff(target) then
						Ban(target, speaker:GetPlayer(), reason, duration)
						
						local logMessage = ("%s was temporarily banned by %s: %s"):format(target.Name, speaker.Name, reason)
						Logs.PublicLog:SendSystemMessage(logMessage, successExtraData)
						Logs.StaffLog:SendSystemMessage(logMessage, successExtraData)
					else
						speaker:SendSystemMessage(("Cannot temporarily ban %s because they are a staff member."):format(target.Name), channelName, errorExtraData)
					end
				else
					speaker:SendSystemMessage("Could not find a single player whose name starts with '"..parts[1].."'.", channelName, errorExtraData)
				end
			end
		end;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "ban";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			local usage = "/ban <player> <reason>"
			
			if #parts < 2 then
				speaker:SendSystemMessage(usage, channelName, errorExtraData)
			else
				local reason = table.concat(parts, " ", 2)
				local target = PlayerMatcher.MatchSinglePlayer(parts[1])
				
				if target then
					if not RankChecker.IsStaff(target) then
						Ban(target, speaker:GetPlayer(), reason, -1)
				
						local logMessage = ("%s was permanently banned by %s: %s"):format(target.Name, speaker.Name, reason)
						Logs.PublicLog:SendSystemMessage(logMessage, successExtraData)
						Logs.StaffLog:SendSystemMessage(logMessage, successExtraData)
					else
						speaker:SendSystemMessage(("Cannot ban %s because they are a staff member."):format(target.Name), channelName, errorExtraData)
					end
				else
					speaker:SendSystemMessage("Could not find a single player whose name starts with '"..parts[1].."'.", channelName, errorExtraData)
				end
			end
		end;
	})
	
	Players.PlayerAdded:Connect(function(player)
		local banData = GetBanData(player)
		
		if banData and not HasBanExpired(banData) then
			player:Kick(GetBanMessage(banData))
		end
	end)
end

return Run
