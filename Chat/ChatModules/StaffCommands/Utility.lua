-- Utility commands.
local Players = game:GetService("Players")

local import = require(game:GetService("ReplicatedStorage"):WaitForChild("Import"))
local DataAccessor = import "~/Data/DataAccessor"
local RankChecker = import "~/Commands/RankChecker"
local PlayerMatcher = import "~/Commands/PlayerMatcher"
local CommandAdder = import "~/Commands/CommandAdder"
local PlayerCharacter = import "~/Utility/PlayerCharacter"
local String = import "~/Utility/String"
local Hierarchy = import "~/Utility/Hierarchy"
local SharedStats = import "~/Stats/SharedStats"

local ChatSettings = import("ClientChatModules/ChatSettings", game:GetService("Chat"))

local errorExtraData = {ChatColor = ChatSettings.ErrorMessageTextColor or Color3.fromRGB(245, 50, 50)}
local successExtraData = {ChatColor = ChatSettings.AdminSuccessTextColor}
local warnExtraData = {ChatColor = Color3.fromRGB(108, 163, 252)}

local function Run(ChatService, Logs)
	local function HandleFreezeStats(channelName, speaker, parts)
		local usage = "Usage: /freezestats <players>"
		
		if #parts ~= 1 then
			speaker:SendSystemMessage(usage, channelName, errorExtraData)
		else
			local sender = speaker:GetPlayer()
			local targets = PlayerMatcher.Match(sender, parts[1], true)
			local set = {}
			
			for _, target in ipairs(targets) do
				DataAccessor.Set(target, "Stats.StatsFrozen", true)
				table.insert(set, target.Name)
						
				local playerSpeaker = ChatService:GetSpeaker(target.Name)
				if playerSpeaker ~= nil and target ~= sender then
					playerSpeaker:SendSystemMessage(("%s froze your stats."):format(sender.Name), Logs.PublicLog.Name, successExtraData)
				end
			end
			
			if #set > 0 then
				Logs.StaffLog:SendSystemMessage(("%s froze the stats of %s."):format(sender.Name, table.concat(set, ", ")))
			else
				speaker:SendSystemMessage("No players' stats were frozen.", channelName, errorExtraData)
			end
		end
	end
	
	local function HandleThawStats(channelName, speaker, parts)
		local usage = "Usage: /thawstats <players>"
		
		if #parts ~= 1 then
			speaker:SendSystemMessage(usage, channelName, errorExtraData)
		else
			local sender = speaker:GetPlayer()
			local targets = PlayerMatcher.Match(sender, parts[1], true)
			local set = {}
			
			for _, target in ipairs(targets) do
				DataAccessor.Set(target, "Stats.StatsFrozen", false)
				table.insert(set, target.Name)
						
				local playerSpeaker = ChatService:GetSpeaker(target.Name)
				if playerSpeaker ~= nil and target ~= sender then
					playerSpeaker:SendSystemMessage(("%s thawed your stats."):format(sender.Name), Logs.PublicLog.Name, successExtraData)
				end
			end
			
			if #set > 0 then
				Logs.StaffLog:SendSystemMessage(("%s thawed the stats of %s."):format(sender.Name, table.concat(set, ", ")))
			else
				speaker:SendSystemMessage("No players' stats were thawed.", channelName, errorExtraData)
			end
		end
	end
	
	CommandAdder.AddCommand(ChatService, {
		Name = "freezestats";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = HandleFreezeStats;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "thawstats";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = HandleThawStats;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "time";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			local hh = String.PadLeft(tostring(tonumber(parts[1]) or 0), 2, '0')
			local mm = String.PadLeft(tostring(tonumber(parts[2]) or 0), 2, '0')
			local ss = String.PadLeft(tostring(tonumber(parts[3]) or 0), 2, '0')
			local timeOfDayString = ("%s:%s:%s"):format(hh, mm, ss)
			game:GetService("Lighting").TimeOfDay = timeOfDayString
			Logs.PublicLog:SendSystemMessage(("%s set the time of day to %s"):format(speaker:GetPlayer().Name, timeOfDayString))
		end;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "respawn";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			local usage = "Usage: /respawn <players>"
		
			if #parts ~= 1 then
				speaker:SendSystemMessage(usage, channelName, errorExtraData)
			else
				local sender = speaker:GetPlayer()
				local targets = PlayerMatcher.Match(sender, parts[1], true)
				local set = {}
				
				for _, target in ipairs(targets) do
					target:LoadCharacter()
					table.insert(set, target.Name)
							
					local playerSpeaker = ChatService:GetSpeaker(target.Name)
					if playerSpeaker ~= nil and target ~= sender then
						playerSpeaker:SendSystemMessage(("%s respawned you."):format(sender.Name), Logs.PublicLog.Name, successExtraData)
					end
				end
				
				if #set > 0 then
					Logs.StaffLog:SendSystemMessage(("%s respawned %s."):format(sender.Name, table.concat(set, ", ")))
				else
					speaker:SendSystemMessage("No players were respawned.", channelName, errorExtraData)
				end
			end
		end
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "warn";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			local usage = "Usage: /warn <players> <message>"
			
			if #parts < 2 then
				speaker:SendSystemMessage(usage, channelName, errorExtraData)
			else
				local targets = PlayerMatcher.Match(speaker:GetPlayer(), parts[1], true)
				local message = table.concat(parts, " ", 2)
				
				for _, target in ipairs(targets) do
					local targetSpeaker = ChatService:GetSpeaker(target.Name)
					targetSpeaker:SendMessage(message, Logs.PublicLog.Name, speaker.Name, warnExtraData)
				end
			end
		end;
	})
	
	local statNames = { "Vitality", "Hunger", "Thirst", "Saturation" }
	CommandAdder.AddCommand(ChatService, {
		Name = "change";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			local usage = "Usage: /change <players> <stat> <value>"
			local sender = speaker:GetPlayer()
			local statFragment = parts[2]
			local value = tonumber(parts[3])
			
			local statName do
				if statFragment then
					for _, name in ipairs(statNames) do
						if name:lower():sub(1, statFragment:len()) == statFragment:lower() then
							statName = name
						end
					end
				end
			end
			
			if #parts ~= 3 then
				speaker:SendSystemMessage(usage, channelName, errorExtraData)
			elseif not statName then
				speaker:SendSystemMessage(("The stat '%s' cannot be found."):format(statFragment), channelName, errorExtraData)
			else
				local targets = PlayerMatcher.Match(speaker:GetPlayer(), parts[1], true)
				local set = {}
				
				for _, target in ipairs(targets) do
					SharedStats.Set(target, statName, value)
					table.insert(set, target.Name)
					
					local playerSpeaker = ChatService:GetSpeaker(target.Name)
					if playerSpeaker ~= nil and target ~= sender then
						playerSpeaker:SendSystemMessage(("%s changed your %s to %d."):format(sender.Name, statName, value), Logs.PublicLog.Name, successExtraData)
					end
				end
				
				if #set > 0 then
					Logs.StaffLog:SendSystemMessage(("%s changed the stat %s to %d for %s."):format(sender.Name, statName, value, table.concat(set, ", ")))
				else
					speaker:SendSystemMessage("No players' stats were changed.", channelName, errorExtraData)
				end
			end
		end;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "give";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			local usage = "Usage: /give <players> <item>[ <quantity>]"
			local sender = speaker:GetPlayer()
			
			if #parts < 2 then
				speaker:SendSystemMessage(usage, channelName, errorExtraData)
			else
				local targets = PlayerMatcher.Match(speaker:GetPlayer(), parts[1], true)
				local quantity = tonumber(parts[#parts])
				local itemName
				
				if quantity then
					itemName = table.concat(parts, " ", 2, #parts - 1)
					quantity = math.min(quantity, 25)
				else
					itemName = table.concat(parts, " ", 2)
					quantity = 1
				end
				
				itemName = itemName:lower()
				local set = {}
				local itemSet = {}
				local itemNameSet = {}
				
				if #targets == 0 then
					speaker:SendSystemMessage("No players were selected.", channelName, errorExtraData)
					return
				end
				
				for _, target in ipairs(targets) do
					table.insert(set, target.Name)
				end
				
				for _, item in ipairs(game:GetService("ReplicatedStorage").Items:GetChildren()) do
					if item.Name:lower():sub(1, itemName:len()) == itemName or itemName == "all" then
						table.insert(itemSet, item)
						table.insert(itemNameSet, item.Name)
					end
				end
				
				for _, target in ipairs(targets) do
					for _, item in ipairs(itemSet) do
						for i = 1, quantity do
							local copy = item:Clone()
							copy.Parent = copy:IsA("BackpackItem") and target.Backpack or game:GetService("ReplicatedStorage").StarterTools.Inventory.Inventories[target.UserId]
						end
					end
					
					local playerSpeaker = ChatService:GetSpeaker(target.Name)
					if playerSpeaker ~= nil and target ~= sender then
						playerSpeaker:SendSystemMessage(("%s gave you %d of %s."):format(sender.Name, quantity, table.concat(itemNameSet, ", ")), Logs.PublicLog.Name, successExtraData)
					end
				end
				
				Logs.StaffLog:SendSystemMessage(("%s gave %s %d of %s."):format(sender.Name, table.concat(set, ", "), quantity, table.concat(itemNameSet, ", ")))
			end
		end;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "removetools";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			local usage = "Usage: /removetools <players>[ <filter>]"
		
			if #parts < 1 then
				speaker:SendSystemMessage(usage, channelName, errorExtraData)
			else
				local sender = speaker:GetPlayer()
				local targets = PlayerMatcher.Match(sender, parts[1], true)
				local filter = table.concat(parts, " ", 2):lower()
				local set = {}
				
				for _, target in ipairs(targets) do
					table.insert(set, target.Name)
					
					for _, tool in ipairs(target.Backpack:GetChildren()) do
						if tool.Name:lower():sub(1, filter:len()) == filter and not DataAccessor.Get(tool, "StarterTool") then
							tool:Destroy()
						end
					end
							
					local playerSpeaker = ChatService:GetSpeaker(target.Name)
					if playerSpeaker ~= nil and target ~= sender then
						playerSpeaker:SendSystemMessage(("%s removed your tools starting with '%s'."):format(sender.Name, filter), Logs.PublicLog.Name, successExtraData)
					end
				end
				
				if #set > 0 then
					Logs.StaffLog:SendSystemMessage(("%s removed the tools of %s, filtered by '%s'."):format(sender.Name, table.concat(set, ", "), filter))
				else
					speaker:SendSystemMessage("No players' tools were removed.", channelName, errorExtraData)
				end
			end
		end
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "removeitems";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			local usage = "Usage: /removeitems <players>[ <filter>]"
		
			if #parts < 1 then
				speaker:SendSystemMessage(usage, channelName, errorExtraData)
			else
				local sender = speaker:GetPlayer()
				local targets = PlayerMatcher.Match(sender, parts[1], true)
				local filter = table.concat(parts, " ", 2):lower()
				local set = {}
				
				for _, target in ipairs(targets) do
					table.insert(set, target.Name)
					
					for _, item in ipairs(game:GetService("ReplicatedStorage").StarterTools.Inventory.Inventories[target.UserId]:GetChildren()) do
						if item.Name:lower():sub(1, filter:len()) == filter then
							item:Destroy()
						end
					end

					local playerSpeaker = ChatService:GetSpeaker(target.Name)
					if playerSpeaker ~= nil and target ~= sender then
						playerSpeaker:SendSystemMessage(("%s removed your items starting with '%s'."):format(sender.Name, filter), Logs.PublicLog.Name, successExtraData)
					end
				end
				
				if #set > 0 then
					Logs.StaffLog:SendSystemMessage(("%s removed the items of %s, filtered by '%s'."):format(sender.Name, table.concat(set, ", "), filter))
				else
					speaker:SendSystemMessage("No players' items were removed.", channelName, errorExtraData)
				end
			end
		end
	})

	CommandAdder.AddCommand(ChatService, {
		Name = "store";
		MinimumRank = 0;
		Execute = function(channelName, speaker, parts)
			local usage = "Usage: /store <filter|all>[ <limit>]"
			local limit = tonumber(parts[#parts])
			local sender = speaker:GetPlayer()

			if #parts < 1 then
				speaker:SendSystemMessage(usage, channelName, errorExtraData)
			elseif not PlayerCharacter.IsAlive(sender) or sender.Character.Humanoid.Health < sender.Character.Humanoid.MaxHealth * 0.7 then
				speaker:SendSystemMessage("You've been hurt and cannot store tools.", channelName, errorExtraData)
			else
				local filter = table.concat(parts, " ", 1, limit and #parts - 1 or #parts):lower()
				local count = 0

				for _, tool in ipairs(sender.Backpack:GetChildren()) do
					if not DataAccessor.Get(tool, "StarterTool") and not DataAccessor.Get(tool, "Working") and tool.Name ~= "Resting" then
						if filter == "all" or tool.Name:lower():sub(1, filter:len()) == filter then
							tool.Parent = sender.Tools
							count = count + 1

							if limit and count >= limit then
								break
							end
						end
					end
				end

				if count > 0 then
					speaker:SendSystemMessage(("Stored %d tool%s."):format(count, count == 1 and "" or "s"), channelName, successExtraData)
				else
					speaker:SendSystemMessage("No tools were stored.", channelName, errorExtraData)
				end
			end
		end
	})

	CommandAdder.AddCommand(ChatService, {
		Name = "take";
		MinimumRank = 0;
		Execute = function(channelName, speaker, parts)
			local usage = "Usage: /take <filter|all>[ <limit>]"
			local limit = tonumber(parts[#parts])
			local sender = speaker:GetPlayer()

			if #parts < 1 then
				speaker:SendSystemMessage(usage, channelName, errorExtraData)
			else
				local filter = table.concat(parts, " ", 1, limit and #parts - 1 or #parts):lower()
				local count = 0

				for _, tool in ipairs(sender.Tools:GetChildren()) do
					if filter == "all" or tool.Name:lower():sub(1, filter:len()) == filter then
						tool.Parent = sender.Backpack
						count = count + 1

						if limit and count >= limit then
							break
						end
					end
				end

				if count > 0 then
					speaker:SendSystemMessage(("Took %d tool%s."):format(count, count == 1 and "" or "s"), channelName, successExtraData)
				else
					speaker:SendSystemMessage("No tools were taken.", channelName, errorExtraData)
				end
			end
		end
	})
	
	local function OnPlayerAdded(player)
		Instance.new("Folder", player).Name = "Tools"
	end
	
	for _, player in ipairs(Players:GetPlayers()) do
		OnPlayerAdded(player)
	end
	
	Players.PlayerAdded:Connect(OnPlayerAdded)
end

return Run
