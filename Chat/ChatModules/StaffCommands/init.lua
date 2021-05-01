-- Root initialization module for the staff commands
-- Performs setup tasks that must be done before any other staff command modules run
-- Also runs the other modules

local Load = require(game:GetService("ReplicatedStorage"):WaitForChild("Load"))
local RankChecker = Load "Commands.RankChecker"

local function Run(ChatService)
	local privateChannel = ChatService:AddChannel("Staff Log")
	privateChannel.AutoJoin = false
	privateChannel.Joinable = false
	privateChannel.Leavable = false
	privateChannel.WelcomeMessage = "All staff actions will be logged here; this channel is accessible only to staff members."
	
	local publicChannel = ChatService:AddChannel("Public Log")
	publicChannel.AutoJoin = true
	publicChannel.Leavable = false
	publicChannel.WelcomeMessage = "Major staff actions will be logged here."
	
	privateChannel.SpeakerJoined:Connect(function(speakerName)
		privateChannel:MuteSpeaker(speakerName)
	end)
	
	publicChannel.SpeakerJoined:Connect(function(speakerName)
		publicChannel:MuteSpeaker(speakerName)
	end)
	
	ChatService.SpeakerAdded:Connect(function(speakerName)
		local speaker = ChatService:GetSpeaker(speakerName)
		
		if speaker and speaker:GetPlayer() then
			if RankChecker.IsStaff(speaker:GetPlayer()) then
				speaker:JoinChannel("Staff Log")
			end
		end
	end)
	
	for _, subModule in ipairs(script:GetChildren()) do
		require(subModule)(ChatService, {
			StaffLog = privateChannel;
			PublicLog = publicChannel;
		})
	end
end

return Run