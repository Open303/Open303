--This module relies on using InsertService to load a custom btools uploaded to the 303 community group.
--For now, I've commented it all out, but if we ever get the files for this model:
--https://www.roblox.com/library/749360029/BTools
--Then o303 can have btools again.

return function(ChatService, Logs)
	return nil
end

--[[
local BtoolsId = 749360029

local Load = require(game:GetService("ReplicatedStorage"):WaitForChild("Load"))
local RankChecker = Load "Commands.RankChecker"
local PlayerMatcher = Load "Commands.PlayerMatcher"
local CommandAdder = Load "Commands.CommandAdder"
local PlayerCharacter = Load "Utility.PlayerCharacter"

local ChatSettings = Load("ClientChatModules.ChatSettings", game:GetService("Chat"))

local errorExtraData = {ChatColor = ChatSettings.ErrorMessageTextColor or Color3.fromRGB(245, 50, 50)}
local successExtraData = {ChatColor = ChatSettings.AdminSuccessTextColor}

local btools = game:GetService("InsertService"):LoadAsset(BtoolsId):GetChildren()[1]

local function Run(ChatService, Logs)
	local function HandleGiveBtools(channelName, speaker, parts)
		if #parts == 0 then
			speaker:SendSystemMessage("Usage: /givebtools <players>", channelName, errorExtraData)
		else
			local sender = speaker:GetPlayer()
			local targets = PlayerMatcher.Match(sender, table.concat(parts, ","), false)
			local set = {}
			
			for _, target in ipairs(targets) do
				if RankChecker.IsStaff(target) then
					table.insert(set, target.Name)
					btools:Clone().Parent = target:FindFirstChild("Backpack")
				end
			end
			
			if #set > 0 then
				Logs.StaffLog:SendSystemMessage(("%s gave btools to %s"):format(sender.Name, table.concat(set, ", ")))
			else
				speaker:SendSystemMessage("No players were specified. Btools can only be given to staff members.", channelName, errorExtraData)
			end
		end
	end
	
	CommandAdder.AddCommand(ChatService, {
		Name = "givebtools";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = HandleGiveBtools;
	})
end

return Run
--]]