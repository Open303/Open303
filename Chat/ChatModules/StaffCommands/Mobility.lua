local MIN_SPEED = 10
local MAX_SPEED = 1000

local MIN_JUMPPOWER = 0
local MAX_JUMPPOWER = 250

local import = require(game:GetService("ReplicatedStorage"):WaitForChild("Import"))
local RankChecker = import "~/Commands/RankChecker"
local PlayerMatcher = import "~/Commands/PlayerMatcher"
local CommandAdder = import "~/Commands/CommandAdder"
local PlayerCharacter = import "~/Utility/PlayerCharacter"
local Hierarchy = import "~/Utility/Hierarchy"

local ChatSettings = import("ClientChatModules/ChatSettings", game:GetService("Chat"))

local errorExtraData = {ChatColor = ChatSettings.ErrorMessageTextColor or Color3.fromRGB(245, 50, 50)}
local successExtraData = {ChatColor = ChatSettings.AdminSuccessTextColor}

-- Sets a character's experienced gravity to a certain value.
local function SetGravity(character, gravity)
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end
	
	local gravityObject = rootPart:FindFirstChild("AdminGravity")
	if not gravityObject then
		gravityObject = Instance.new("BodyForce")
		gravityObject.Name = "AdminGravity"
		gravityObject.Parent = rootPart
	end
	
	local mass = 0
	Hierarchy.CallOnDescendants(character, function(child)
		if child:IsA("BasePart") then
			mass = mass + child:GetMass()
		end
	end)
	
	gravityObject.Force = Vector3.new(0, mass * gravity, 0)
end

local function Run(ChatService, Logs)
	local islandTeleports = {}
	local islandTeleportStrings = {}
	local marks = {}
	
	for _, object in ipairs(workspace.StartupObjects.TeleportWaypoints:GetChildren()) do
		local point = object.Position
		
		for name in object.Name:gmatch("[^|]+") do
			islandTeleports[name] = point
		end
		
		object.Transparency = 1
	end
	
	local function HandleWalkSpeed(channelName, speaker, parts)
		local speed = tonumber(parts[2])
		local usage = "Usage: /walkspeed <players> <speed (number)>"
		
		if #parts ~= 2 then
			speaker:SendSystemMessage(usage, channelName, errorExtraData)
		elseif speed == nil then
			speaker:SendSystemMessage(usage, channelName, errorExtraData)
		else
			local sender = speaker:GetPlayer()
			local targets = PlayerMatcher.Match(sender, parts[1], true)
			local clampedSpeed = math.min(math.max(MIN_SPEED, speed), MAX_SPEED)
			local set = {}
			
			for _, target in ipairs(targets) do
				if PlayerCharacter.IsAlive(target) then
					local humanoid = PlayerCharacter.GetHumanoid(target)
					
					if humanoid ~= nil then
						humanoid.WalkSpeed = clampedSpeed
						table.insert(set, target.Name)
						
						local playerSpeaker = ChatService:GetSpeaker(target.Name)
						if playerSpeaker ~= nil and target ~= sender then
							playerSpeaker:SendSystemMessage(("%s set your walkspeed to %d."):format(sender.Name, clampedSpeed), Logs.PublicLog.Name, successExtraData)
						end
					end
				end
			end
			
			if #set > 0 then
				Logs.StaffLog:SendSystemMessage(("%s set the walkspeed of %s to %d."):format(sender.Name, table.concat(set, ", "), clampedSpeed))
			else
				speaker:SendSystemMessage("No players' walkspeeds were changed.", channelName, errorExtraData)
			end
		end
	end
	
	local function HandleMark(channelName, speaker, parts)
		local usage = "Usage: /mark <name>"
		local player = speaker:GetPlayer()
		
		if #parts ~= 1 then
			speaker:SendSystemMessage(usage, channelName, errorExtraData)
		else
			if PlayerCharacter.IsAlive(player) then
				if not marks[player.UserId] then
					marks[player.UserId] = {}
				end
				
				marks[player.UserId][parts[1]] = player.Character.PrimaryPart.Position
				speaker:SendSystemMessage(("Mark '%s' set."):format(parts[1]), channelName, successExtraData)
			end
		end
	end
	
	local function HandleRecall(channelName, speaker, parts)
		local usage = "Usage: /recall <name>"
		local player = speaker:GetPlayer()
		local point = marks[player.UserId] and marks[player.UserId][parts[1]]
		
		if #parts ~= 1 then
			speaker:SendSystemMessage(usage, channelName, errorExtraData)
		elseif not point then
			speaker:SendSystemMessage(("The mark '%s' does not exist."):format(parts[1]), channelName, errorExtraData)
		else
			if PlayerCharacter.IsAlive(player) then
				player.Character:MoveTo(point)
			end
		end
	end
	
	local function HandleJumpPower(channelName, speaker, parts)
		local power = tonumber(parts[2])
		local usage = "Usage: /jumppower <players> <power (number)>"
		
		if #parts ~= 2 or not power then
			speaker:SendSystemMessage(usage, channelName, errorExtraData)
		else
			local sender = speaker:GetPlayer()
			local targets = PlayerMatcher.Match(sender, parts[1], true)
			local clampedPower = math.min(math.max(MIN_JUMPPOWER, power), MAX_JUMPPOWER)
			local set = {}
			
			for _, target in ipairs(targets) do
				if PlayerCharacter.IsAlive(target) then
					local humanoid = PlayerCharacter.GetHumanoid(target)
					
					if humanoid ~= nil then
						humanoid.JumpPower = clampedPower
						table.insert(set, target.Name)
						
						local playerSpeaker = ChatService:GetSpeaker(target.Name)
						if playerSpeaker ~= nil and target ~= sender then
							playerSpeaker:SendSystemMessage(("%s set your jump power to %d."):format(sender.Name, clampedPower), Logs.PublicLog.Name, successExtraData)
						end
					end
				end
			end
			
			if #set > 0 then
				Logs.StaffLog:SendSystemMessage(("%s set the jump power of %s to %d."):format(sender.Name, table.concat(set, ", "), clampedPower))
			else
				speaker:SendSystemMessage("No players' jump powers were changed.", channelName, errorExtraData)
			end
		end
	end
	
	local function HandleTeleport(channelName, speaker, parts)
		local usage = "/teleport <players> <target>"
		
		if #parts ~= 2 then
			speaker:SendSystemMessage(usage, channelName, errorExtraData)
		else
			local sender = speaker:GetPlayer()
			local teleportees = PlayerMatcher.Match(sender, parts[1], true)
			local targetString = parts[2]
			local targetPlayers = PlayerMatcher.Match(sender, targetString, false)
			local targetPoint, targetDescription
			
			if #targetPlayers == 1 then
				local targetPlayer = targetPlayers[1]
				
				if PlayerCharacter.IsAlive(targetPlayer) then
					targetPoint = targetPlayer.Character.PrimaryPart.Position
					targetDescription = "player "..targetPlayer.Name
				end
			else
				for waypointName, waypointPoint in pairs(islandTeleports) do
					if waypointName:lower():sub(1, targetString:len()) == targetString then
						targetDescription = "waypoint "..waypointName
						targetPoint = waypointPoint
						break
					end
				end
			end
			
			if targetPoint and targetDescription then
				local set = {}
				
				for _, teleportee in ipairs(teleportees) do
					if PlayerCharacter.IsAlive(teleportee) then
						table.insert(set, teleportee.Name)
						teleportee.Character:MoveTo(targetPoint)
						
						local playerSpeaker = ChatService:GetSpeaker(teleportee.Name)
						if playerSpeaker ~= nil and teleportee ~= sender then
							playerSpeaker:SendSystemMessage(("%s teleported you to %s."):format(sender.Name, targetDescription), Logs.PublicLog.Name, successExtraData)
						end
					end
				end
				
				if #set > 0 then
					Logs.StaffLog:SendSystemMessage(("%s teleported %s to %s."):format(sender.Name, table.concat(set, ", "), targetDescription))
				else
					speaker:SendSystemMessage("No players were teleported.", channelName, errorExtraData)
				end
			else
				speaker:SendSystemMessage(("Teleport target '%s' was not found."):format(targetString), channelName, errorExtraData)
			end
		end
	end
	
	local function HandleSetGrav(channelName, speaker, parts)
		local gravity = tonumber(parts[2])
		local usage = "Usage: /setgrav <players> <gravity>"
		
		if #parts ~= 2 or not gravity then
			speaker:SendSystemMessage(usage, channelName, errorExtraData)
		else
			local sender = speaker:GetPlayer()
			local targets = PlayerMatcher.Match(sender, parts[1], false)
			local set = {}
			
			for _, target in ipairs(targets) do
				if PlayerCharacter.IsAlive(target) then
					SetGravity(target.Character, gravity)
					table.insert(set, target.Name)
						
					local playerSpeaker = ChatService:GetSpeaker(target.Name)
					if playerSpeaker ~= nil and target ~= sender then
						playerSpeaker:SendSystemMessage(("%s set your gravity to %d."):format(sender.Name, gravity), Logs.PublicLog.Name, successExtraData)
					end
				end
			end
			
			if #set > 0 then
				Logs.StaffLog:SendSystemMessage(("%s set the gravity of %s to %d."):format(sender.Name, table.concat(set, ", "), gravity))
			else
				speaker:SendSystemMessage("No players' gravities were changed.", channelName, errorExtraData)
			end
		end
	end
	
	local function HandleGrav(channelName, speaker, parts)
		local usage = "Usage: /grav <players>"
		
		if #parts ~= 1 then
			speaker:SendSystemMessage(usage, channelName, errorExtraData)
		else
			local sender = speaker:GetPlayer()
			local targets = PlayerMatcher.Match(sender, parts[1], false)
			local set = {}
			
			for _, target in ipairs(targets) do
				if PlayerCharacter.IsAlive(target) then
					SetGravity(target.Character, 0)
					table.insert(set, target.Name)
						
					local playerSpeaker = ChatService:GetSpeaker(target.Name)
					if playerSpeaker ~= nil and target ~= sender then
						playerSpeaker:SendSystemMessage(("%s reset your gravity."):format(sender.Name), Logs.PublicLog.Name, successExtraData)
					end
				end
			end
			
			if #set > 0 then
				Logs.StaffLog:SendSystemMessage(("%s reset the gravity of %s."):format(sender.Name, table.concat(set, ", ")))
			else
				speaker:SendSystemMessage("No players' gravities were reset.", channelName, errorExtraData)
			end
		end
	end
	
	local function HandleAntigrav(channelName, speaker, parts)
		local usage = "Usage: /antigrav <players>"
		
		if #parts ~= 1 then
			speaker:SendSystemMessage(usage, channelName, errorExtraData)
		else
			local sender = speaker:GetPlayer()
			local targets = PlayerMatcher.Match(sender, parts[1], false)
			local set = {}
			
			for _, target in ipairs(targets) do
				if PlayerCharacter.IsAlive(target) then
					SetGravity(target.Character, 140)
					table.insert(set, target.Name)
						
					local playerSpeaker = ChatService:GetSpeaker(target.Name)
					if playerSpeaker ~= nil and target ~= sender then
						playerSpeaker:SendSystemMessage(("%s gave you antigravity."):format(sender.Name), Logs.PublicLog.Name, successExtraData)
					end
				end
			end
			
			if #set > 0 then
				Logs.StaffLog:SendSystemMessage(("%s gave %s antigravity."):format(sender.Name, table.concat(set, ", ")))
			else
				speaker:SendSystemMessage("No players were given antigravity.", channelName, errorExtraData)
			end
		end
	end
	
	local function HandleNograv(channelName, speaker, parts)
		local usage = "Usage: /nograv <players>"
		
		if #parts ~= 1 then
			speaker:SendSystemMessage(usage, channelName, errorExtraData)
		else
			local sender = speaker:GetPlayer()
			local targets = PlayerMatcher.Match(sender, parts[1], false)
			local set = {}
			
			for _, target in ipairs(targets) do
				if PlayerCharacter.IsAlive(target) then
					SetGravity(target.Character, workspace.Gravity)
					table.insert(set, target.Name)
						
					local playerSpeaker = ChatService:GetSpeaker(target.Name)
					if playerSpeaker ~= nil and target ~= sender then
						playerSpeaker:SendSystemMessage(("%s gave you no-gravity."):format(sender.Name), Logs.PublicLog.Name, successExtraData)
					end
				end
			end
			
			if #set > 0 then
				Logs.StaffLog:SendSystemMessage(("%s gave %s no-gravity."):format(sender.Name, table.concat(set, ", ")))
			else
				speaker:SendSystemMessage("No players were given no-gravity.", channelName, errorExtraData)
			end
		end
	end
	
	CommandAdder.AddCommand(ChatService, {
		Name = "walkspeed";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = HandleWalkSpeed;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "jumppower";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = HandleJumpPower;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "tp";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = HandleTeleport;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "teleport";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = HandleTeleport;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "mark";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = HandleMark;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "recall";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = HandleRecall;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "setgrav";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = HandleSetGrav;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "grav";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = HandleGrav;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "antigrav";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = HandleAntigrav;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "nograv";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = HandleNograv;
	})
end

return Run
