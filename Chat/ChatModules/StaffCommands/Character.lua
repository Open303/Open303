-- Utility commands
local import = require(game:GetService("ReplicatedStorage"):WaitForChild("Import"))
local DataAccessor = import "~/Data/DataAccessor"
local RankChecker = import "~/Commands/RankChecker"
local PlayerMatcher = import "~/Commands/PlayerMatcher"
local CommandAdder = import "~/Commands/CommandAdder"
local PlayerCharacter = import "~/Utility/PlayerCharacter"
local String = import "~/Utility/String"
local Hierarchy = import "~/Utility/Hierarchy"

local ChatSettings = import("ClientChatModules/ChatSettings", game:GetService("Chat"))

local ghostlightToggle = import "~/Commands/GhostlightToggle"

local errorExtraData = {ChatColor = ChatSettings.ErrorMessageTextColor or Color3.fromRGB(245, 50, 50)}
local successExtraData = {ChatColor = ChatSettings.AdminSuccessTextColor}

local function Run(ChatService, Logs)
	local transparencies = {}
	
	CommandAdder.AddCommand(ChatService, {
		Name = "invisible";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			local usage = "Usage: /invisible <players>"
			local sender = speaker:GetPlayer()
			
			if #parts ~= 1 then
				speaker:SendSystemMessage(usage, channelName, errorExtraData)
			else
				local targets = PlayerMatcher.Match(speaker:GetPlayer(), parts[1], true)
				local set = {}
				
				for _, target in ipairs(targets) do
					if PlayerCharacter.IsAlive(target) then
						Hierarchy.CallOnDescendants(target.Character, function(child)
							if child:IsA("BasePart") and not transparencies[child] then
								transparencies[child] = child.Transparency
								child.Transparency = 1
							end
						end)
						
						table.insert(set, target.Name)
						
						local playerSpeaker = ChatService:GetSpeaker(target.Name)
						if playerSpeaker ~= nil and target ~= sender then
							playerSpeaker:SendSystemMessage(("%s made you invisible."):format(sender.Name), Logs.PublicLog.Name, successExtraData)
						end
					end
				end
				
				if #set > 0 then
					Logs.StaffLog:SendSystemMessage(("%s made %s invisible."):format(sender.Name, table.concat(set, ", ")))
				else
					speaker:SendSystemMessage("No players were made invisible.", channelName, errorExtraData)
				end
			end
		end;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "visible";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			local usage = "Usage: /visible <players>"
			local sender = speaker:GetPlayer()
			
			if #parts ~= 1 then
				speaker:SendSystemMessage(usage, channelName, errorExtraData)
			else
				local targets = PlayerMatcher.Match(speaker:GetPlayer(), parts[1], true)
				local set = {}
				
				for _, target in ipairs(targets) do
					if PlayerCharacter.IsAlive(target) then
						Hierarchy.CallOnDescendants(target.Character, function(child)
							if child:IsA("BasePart") and transparencies[child] then
								child.Transparency = transparencies[child]
								transparencies[child] = nil
							end
						end)
						
						table.insert(set, target.Name)
						
						local playerSpeaker = ChatService:GetSpeaker(target.Name)
						if playerSpeaker ~= nil and target ~= sender then
							playerSpeaker:SendSystemMessage(("%s made you visible."):format(sender.Name), Logs.PublicLog.Name, successExtraData)
						end
					end
				end
				
				if #set > 0 then
					Logs.StaffLog:SendSystemMessage(("%s made %s visible."):format(sender.Name, table.concat(set, ", ")))
				else
					speaker:SendSystemMessage("No players were made visible.", channelName, errorExtraData)
				end
			end
		end;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "freeze";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			local usage = "Usage: /freeze <players>"
			local sender = speaker:GetPlayer()
			
			if #parts ~= 1 then
				speaker:SendSystemMessage(usage, channelName, errorExtraData)
			else
				local targets = PlayerMatcher.Match(speaker:GetPlayer(), parts[1], true)
				local set = {}
				
				for _, target in ipairs(targets) do
					if PlayerCharacter.IsAlive(target) then
						target.Character.PrimaryPart.Anchored = true
						table.insert(set, target.Name)
						
						local playerSpeaker = ChatService:GetSpeaker(target.Name)
						if playerSpeaker ~= nil and target ~= sender then
							playerSpeaker:SendSystemMessage(("%s froze you."):format(sender.Name), Logs.PublicLog.Name, successExtraData)
						end
					end
				end
				
				if #set > 0 then
					Logs.StaffLog:SendSystemMessage(("%s froze %s."):format(sender.Name, table.concat(set, ", ")))
				else
					speaker:SendSystemMessage("No players were frozen.", channelName, errorExtraData)
				end
			end
		end;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "thaw";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			local usage = "Usage: /thaw <players>"
			local sender = speaker:GetPlayer()
			
			if #parts ~= 1 then
				speaker:SendSystemMessage(usage, channelName, errorExtraData)
			else
				local targets = PlayerMatcher.Match(speaker:GetPlayer(), parts[1], true)
				local set = {}
				
				for _, target in ipairs(targets) do
					if PlayerCharacter.IsAlive(target) then
						target.Character.PrimaryPart.Anchored = false
						table.insert(set, target.Name)
						
						local playerSpeaker = ChatService:GetSpeaker(target.Name)
						if playerSpeaker ~= nil and target ~= sender then
							playerSpeaker:SendSystemMessage(("%s thawed you."):format(sender.Name), Logs.PublicLog.Name, successExtraData)
						end
					end
				end
				
				if #set > 0 then
					Logs.StaffLog:SendSystemMessage(("%s thawed %s."):format(sender.Name, table.concat(set, ", ")))
				else
					speaker:SendSystemMessage("No players were thawed.", channelName, errorExtraData)
				end
			end
		end;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "kill";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			local usage = "Usage: /kill <players>"
			local sender = speaker:GetPlayer()
			
			if #parts ~= 1 then
				speaker:SendSystemMessage(usage, channelName, errorExtraData)
			else
				local targets = PlayerMatcher.Match(speaker:GetPlayer(), parts[1], true)
				local set = {}
				
				for _, target in ipairs(targets) do
					if PlayerCharacter.IsAlive(target) then
						target.Character:BreakJoints()
						table.insert(set, target.Name)
						
						local playerSpeaker = ChatService:GetSpeaker(target.Name)
						if playerSpeaker ~= nil and target ~= sender then
							playerSpeaker:SendSystemMessage(("%s killed you."):format(sender.Name), Logs.PublicLog.Name, successExtraData)
						end
					end
				end
				
				if #set > 0 then
					Logs.StaffLog:SendSystemMessage(("%s killed %s."):format(sender.Name, table.concat(set, ", ")))
				else
					speaker:SendSystemMessage("No players were killed.", channelName, errorExtraData)
				end
			end
		end;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "heal";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			local usage = "Usage: /heal <players>"
			local sender = speaker:GetPlayer()
			
			if #parts ~= 1 then
				speaker:SendSystemMessage(usage, channelName, errorExtraData)
			else
				local targets = PlayerMatcher.Match(speaker:GetPlayer(), parts[1], true)
				local set = {}
				
				for _, target in ipairs(targets) do
					if PlayerCharacter.IsAlive(target) then
						local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
						
						if humanoid then
							humanoid.Health = humanoid.MaxHealth
							table.insert(set, target.Name)
						
							local playerSpeaker = ChatService:GetSpeaker(target.Name)
							if playerSpeaker ~= nil and target ~= sender then
								playerSpeaker:SendSystemMessage(("%s healed you."):format(sender.Name), Logs.PublicLog.Name, successExtraData)
							end
						end
					end
				end
				
				if #set > 0 then
					Logs.StaffLog:SendSystemMessage(("%s healed %s."):format(sender.Name, table.concat(set, ", ")))
				else
					speaker:SendSystemMessage("No players were healed.", channelName, errorExtraData)
				end
			end
		end;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "health";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			local usage = "Usage: /health <players> <health>"
			local health = tonumber(parts[2])
			local sender = speaker:GetPlayer()
			
			if #parts ~= 2 or not health then
				speaker:SendSystemMessage(usage, channelName, errorExtraData)
			else
				local targets = PlayerMatcher.Match(speaker:GetPlayer(), parts[1], true)
				local set = {}
				
				for _, target in ipairs(targets) do
					if PlayerCharacter.IsAlive(target) then
						local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
						
						if humanoid then
							humanoid.MaxHealth = health
							humanoid.Health = health
							table.insert(set, target.Name)
						
							local playerSpeaker = ChatService:GetSpeaker(target.Name)
							if playerSpeaker ~= nil and target ~= sender then
								playerSpeaker:SendSystemMessage(("%s set your maximum health to %d."):format(sender.Name, health), Logs.PublicLog.Name, successExtraData)
							end
						end
					end
				end
				
				if #set > 0 then
					Logs.StaffLog:SendSystemMessage(("%s set the health of %s to %d."):format(sender.Name, table.concat(set, ", "), health))
				else
					speaker:SendSystemMessage("No players' healths were changed.", channelName, errorExtraData)
				end
			end
		end;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "damage";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			local usage = "Usage: /damage <players> <damage>"
			local damage = tonumber(parts[2])
			local sender = speaker:GetPlayer()
			
			if #parts ~= 2 or not damage then
				speaker:SendSystemMessage(usage, channelName, errorExtraData)
			else
				local targets = PlayerMatcher.Match(speaker:GetPlayer(), parts[1], true)
				local set = {}
				
				for _, target in ipairs(targets) do
					if PlayerCharacter.IsAlive(target) then
						local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
						
						if humanoid then
							humanoid:TakeDamage(damage)
							table.insert(set, target.Name)
						
							local playerSpeaker = ChatService:GetSpeaker(target.Name)
							if playerSpeaker ~= nil and target ~= sender then
								playerSpeaker:SendSystemMessage(("%s damaged you for %d damage."):format(sender.Name, damage), Logs.PublicLog.Name, successExtraData)
							end
						end
					end
				end
				
				if #set > 0 then
					Logs.StaffLog:SendSystemMessage(("%s damaged %s for %d damage."):format(sender.Name, table.concat(set, ", "), damage))
				else
					speaker:SendSystemMessage("No players were damaged.", channelName, errorExtraData)
				end
			end
		end;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "ff";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			local usage = "Usage: /ff <players>"
			local sender = speaker:GetPlayer()
			
			if #parts ~= 1 then
				speaker:SendSystemMessage(usage, channelName, errorExtraData)
			else
				local targets = PlayerMatcher.Match(speaker:GetPlayer(), parts[1], true)
				local set = {}
				
				for _, target in ipairs(targets) do
					if PlayerCharacter.IsAlive(target) and not target.Character:FindFirstChildOfClass("ForceField") then
						Instance.new("ForceField", target.Character).Name = "ForceField"
						table.insert(set, target.Name)
					
						local playerSpeaker = ChatService:GetSpeaker(target.Name)
						if playerSpeaker ~= nil and target ~= sender then
							playerSpeaker:SendSystemMessage(("%s gave you a forcefield."):format(sender.Name), Logs.PublicLog.Name, successExtraData)
						end
					end
				end
				
				if #set > 0 then
					Logs.StaffLog:SendSystemMessage(("%s gave a forcefield to %s."):format(sender.Name, table.concat(set, ", ")))
				else
					speaker:SendSystemMessage("No players were given forcefields.", channelName, errorExtraData)
				end
			end
		end;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "unff";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			local usage = "Usage: /unff <players>"
			local sender = speaker:GetPlayer()
			
			if #parts ~= 1 then
				speaker:SendSystemMessage(usage, channelName, errorExtraData)
			else
				local targets = PlayerMatcher.Match(speaker:GetPlayer(), parts[1], true)
				local set = {}
				
				for _, target in ipairs(targets) do
					if PlayerCharacter.IsAlive(target) and target.Character:FindFirstChildOfClass("ForceField") then
						target.Character:FindFirstChildOfClass("ForceField"):Destroy()
						table.insert(set, target.Name)
					
						local playerSpeaker = ChatService:GetSpeaker(target.Name)
						if playerSpeaker ~= nil and target ~= sender then
							playerSpeaker:SendSystemMessage(("%s removed your forcefield."):format(sender.Name), Logs.PublicLog.Name, successExtraData)
						end
					end
				end
				
				if #set > 0 then
					Logs.StaffLog:SendSystemMessage(("%s removed the forcefields of %s."):format(sender.Name, table.concat(set, ", ")))
				else
					speaker:SendSystemMessage("No players had their forcefields removed.", channelName, errorExtraData)
				end
			end
		end;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "jump";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			local usage = "Usage: /jump <players>"
			local sender = speaker:GetPlayer()
			
			if #parts ~= 1 then
				speaker:SendSystemMessage(usage, channelName, errorExtraData)
			else
				local targets = PlayerMatcher.Match(speaker:GetPlayer(), parts[1], true)
				local set = {}
				
				for _, target in ipairs(targets) do
					if PlayerCharacter.IsAlive(target) then
						local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
						
						if humanoid then
							humanoid.Jump = true
							table.insert(set, target.Name)
						
							local playerSpeaker = ChatService:GetSpeaker(target.Name)
							if playerSpeaker ~= nil and target ~= sender then
								playerSpeaker:SendSystemMessage(("%s made you jump."):format(sender.Name), Logs.PublicLog.Name, successExtraData)
							end
						end
					end
				end
				
				if #set > 0 then
					Logs.StaffLog:SendSystemMessage(("%s made %s jump."):format(sender.Name, table.concat(set, ", ")))
				else
					speaker:SendSystemMessage("No players were forced to jump.", channelName, errorExtraData)
				end
			end
		end;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "sit";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			local usage = "Usage: /sit <players>"
			local sender = speaker:GetPlayer()
			
			if #parts ~= 1 then
				speaker:SendSystemMessage(usage, channelName, errorExtraData)
			else
				local targets = PlayerMatcher.Match(speaker:GetPlayer(), parts[1], true)
				local set = {}
				
				for _, target in ipairs(targets) do
					if PlayerCharacter.IsAlive(target) then
						local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
						
						if humanoid then
							humanoid.Sit = true
							table.insert(set, target.Name)
						
							local playerSpeaker = ChatService:GetSpeaker(target.Name)
							if playerSpeaker ~= nil and target ~= sender then
								playerSpeaker:SendSystemMessage(("%s made you sit."):format(sender.Name), Logs.PublicLog.Name, successExtraData)
							end
						end
					end
				end
				
				if #set > 0 then
					Logs.StaffLog:SendSystemMessage(("%s made %s sit."):format(sender.Name, table.concat(set, ", ")))
				else
					speaker:SendSystemMessage("No players were forced to sit.", channelName, errorExtraData)
				end
			end
		end;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "ghostlight";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			ghostlightToggle:FireClient(speaker:GetPlayer())
		end;
	})
end

return Run
