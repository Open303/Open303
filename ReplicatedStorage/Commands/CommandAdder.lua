local COMMAND_PREFIX = '/'
local COMMAND_SEPARATOR = ' '

local ChatConstants = require(game:GetService("Chat"):WaitForChild("ClientChatModules"):WaitForChild("ChatConstants"))
local Load = require(game:GetService("ReplicatedStorage"):WaitForChild("Load"))
local RankChecker = Load "Commands.RankChecker"
local String = Load "Utility.String"

local ChatSettings = Load("ClientChatModules.ChatSettings", game:GetService("Chat"))
local errorExtraData = {ChatColor = ChatSettings.ErrorMessageTextColor or Color3.fromRGB(245, 50, 50)}

local CommandAdder = {}

function CommandAdder.AddCommand(ChatService, command)
	local commandStart = COMMAND_PREFIX..command.Name:lower().." "

	local function Process(speakerName, message, channel)
		local speaker = ChatService:GetSpeaker(speakerName)
		local player = speaker:GetPlayer()
		
		if not player then return false end
		if message:sub(1, commandStart:len()) ~= commandStart and message ~= "/"..command.Name then return false end
		if RankChecker.GetGroupRank(player) < command.MinimumRank then
			speaker:SendSystemMessage("You do not have permission to use this command.", channel, errorExtraData)
			return false
		end
		local success, err = pcall(command.Execute, channel, speaker, String.Split(message:sub(commandStart:len() + 1), COMMAND_SEPARATOR))
		
		if not success then
			speaker:SendSystemMessage("An error occurred executing this command.", channel, errorExtraData)
			warn("Unable to execute command "..command.Name..": "..err)
		end
		
		return true
	end
	
	ChatService:RegisterProcessCommandsFunction("AutoAddCommand"..command.Name, Process, ChatConstants.StandardPriority)
end

return CommandAdder