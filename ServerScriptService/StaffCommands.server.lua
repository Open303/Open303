local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"

local PlaceId = game.PlaceId
local Sandbox = PlaceId == 99672070
local VIPServer = game.VIPServerId ~= ''

local ProductionServer = PlaceId == 480485987 and not game:GetService("RunService"):IsStudio()
local StudioMode = (game.CreatorId == 0) or (game:FindService("NetworkServer") == nil)

local AdminTracker = ProductionServer and game:GetService("DataStoreService"):GetDataStore("AdminTracker")

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local HTTPService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local IndemnifyTeleport = game:GetService("ServerScriptService").AntiExploit.IndemnifyTeleport

local ghostlight = Load "Commands.GhostlightToggle"

local function lookupify(tab)
	local newtab = {}
	for i,v in pairs(tab) do
		newtab[v:lower()] = true
	end
	return newtab
end

local editorlist = { "SCARFACIAL", "Chiefwaffles", "halofan987123", "blargety", "MemoryAddress", "worldcrasher" }
local juniorEditors = { }
local adminlist = { "bugslinger", "pokemaster787", "chaoman12", "EvilShogun", "Narcoblix" }
local modlist = { "demiurgic", "ultrabug", "cat8923", "D3m0nicAngel", "FlamePrince", "Billerluvr38" }

if game:GetService("RunService"):IsStudio() then
	table.insert(editorlist, "Player")
	table.insert(editorlist, "Player1")
	table.insert(editorlist, "Player2")
end

local Staff = { modlist, adminlist, juniorEditors, editorlist }
function setStaffLevel(Player, Level)
	for index, tab in pairs(Staff) do
		if index == Level then
			table.insert(tab, Player.Name)
		else
			for i=#tab, 1, -1 do
				if tab[i]:lower() == Player.Name:lower() then
					table.remove(tab, i)
				end
			end
		end
	end	
end

local function Sort(a,b)
	return a:lower() < b:lower()
end

table.sort(editorlist, Sort)
table.sort(juniorEditors, Sort)
table.sort(adminlist, Sort)
table.sort(modlist, Sort)

local bannedlist = lookupify{"Vartax", "chaoman1", "chaoman2", "tanky12", "EE8v8", "PBnJsandwich", "justen1", "LordPhoenixFlare", "luigi4921", "Epicluigi90", "LordKnights", "christianrowe", "deathknight306", "pikminix", "Samurijack1", "JustinThach", "css11199", "Supaepicassasino", "altair", "Blackwidowspider1", "SubjectX7", "preatylittledude", "matej", "cocowarrior21", "Inf4m0us", "2pacWorld3", "Handguy", "heiko", "KRonPaddy", "XDman123h", "Cstaber125", "LordVrexar", "Andyslurp2", "info135", "jooeeeyyyy", "andyslurp2", "Revokz", "SkilledN00B", "zim1337", "reterded12113", "Hulk33445", "husnanqas", "Unpoke", "scardow", "husqas1", "AFriendlyGuest32", "master3411", "davidii2isanoob", "age111", "kremixslayer", "chaoman", "chaoma", "chao", "cha", "chiefwaffl", "chiefwaff", "chiefwaf", "chiefwa", "chiefw", "chief", "chie", "blarget", "blarge", "blarg", "blar", "worldcrashe", "worldcrash", "worldcras", "worldcra", "worldc", "world", "worl", "halofan98712", "halofan9871", "halofan987", "halofan98", "halofan9", "halofan", "Suffixion"}
function TempBan(Player)
	Player:Kick("You have been banned from this server.")
	table.insert(bannedlist, Player.Name)
end

local function check(name, list)
	for i,v in pairs(list) do
		if v:lower() == name:lower() then
			return true
		end
	end
	return false
end

local function staffLevel(name)
	return Sandbox and 2
		or (check(name, juniorEditors) or check(name, editorlist)) and 3
		or check(name, adminlist) and 2
		or check(name, modlist) and 1
		or 0
end

function _G.GetStaffRank(Name)
	return pcall(staffLevel, Name)
end

--local HTTPService = game:GetService("HttpService")
--local DiscordURL = "https://discordapp.com/api/webhooks/289148207227863041/E32n4K8ZibnwEwh-bWgKNvlMXzuDBKOLn5iNvSGUcJUWBAGK2tkyXyo7G68iu5TWLD-M" 
--local Bans = {}
--function PublishBan(Player,Reason)
--	Table = { ["name"] = tostring(Player.UserId), ["desc"] = tostring(Reason), ["idList"] = "58c9a7619789531a1f5fa951"}
--	HTTPService:PostAsync(string.format("https://api.trello.com/1/cards?key=%s&token=%s", "4b25b5ab7cf4970af32e6a7c29929d0d", "ae0654686fd15f8d5b95e8f461108dcd69288c852c1dc20ef37ec2df7ac8026e"),HTTPService:JSONEncode(Table))
--	local BanTable = {
--		['username'] = "Admin Report",
--		['content'] =  Player.Name .. " Was Banned, \n Reason: " .. Reason,
--	}
--	HTTPService:PostAsync(DiscordURL, HTTPService:JSONEncode(BanTable) )
--
--end
--function GrabBans()
--	Banlist = HTTPService:GetAsync('https://api.trello.com/1/lists/58c9a7619789531a1f5fa951/cards?key=4b25b5ab7cf4970af32e6a7c29929d0d&token=',true)
--	Banlist = HTTPService:JSONDecode(Banlist)
--	Bans = {}
--	for i,v in pairs(Banlist) do
--		table.insert(Bans,#Bans + 1,v["name"])
--	end
--end
--coroutine.resume(coroutine.create(function()
--while wait(5) do
--	GrabBans()
--	for i,v in pairs(game.Players:GetChildren()) do
--		for x,z in pairs(Bans) do
--			if tostring(z) == tostring(v.UserId) then
--				game.Players:FindFirstChild(v.Name):Kick("You are banned.")
--			end
--		end
--	end
--end
--end))
--game.Players.PlayerAdded:connect(function(player) 
--	GrabBans()
--	for x,z in pairs(Bans) do
--		if tostring(z) == tostring(player.UserId) then
--			game.Players:FindFirstChild(player.Name):Kick("You are banned.")
--		end
--	end
--end)

local banStore = game:GetService("DataStoreService"):GetDataStore("BansV2")

local function Ban(player, reason)
	banStore:SetAsync(player.UserId, reason)
	player:Kick("You have been banned: "..reason)
end

local function IsBanned(player)
	if not ProductionServer then return false end
	
	for _, name in ipairs(bannedlist) do
		if player.Name == name then
			return true, "<unknown>"
		end
	end
	
	local reason = banStore:GetAsync(player.UserId)
	return reason ~= nil, reason
end

local function SendChat(Player, Message)
--	local Chat = Instance.new("StringValue")
--	Chat.Value = Message or "(Error: Argument missing or nil)"
--	Chat.Parent = Player:WaitForChild("Chat")
end

--[[
Ban Reasons:
Vartax - Exploiting (Scarfacial)
tanky12 - Exploiting (Scarfacial)
EE8v8 - Admitted to exploiting (Scarfacial)
PBnJsandwich - Exploiting. Admitted on comments and I've seen it firsthand twice. (Scarfacial)
justen1 - Exploiting (Scarfacial)
LordPhoenixFlare - Exploiting (Scarfacial)
luigi4921 - Exploiting (Scarfacial)
Epicluigi90 - Exploiting (Scarfacial)
LordKnights - Exploiting (Scarfacial)
christianrowe - Threatening to exploit, spam, etc (Scarfacial)
deathknight306 - Exploiting (Scarfacial)
pikminix - Exploiting (Scarfacial)
Samurijack1 - Exploiting (Scarfacial)
JustinThach - Exploiting (Scarfacial)
css11199 - Exploiting (Scarfacial)
Supaepicassasino - Exploiting (Halo)
altair - Exploiting (Halo)
preatylittledude - Exploiting (Halo)
SubjectX7 - Exploiting (Halo)
Blackwidowspider1 - Exploiting (Halo)
matej - Exploiting (Halo)
cocowarrior21 - Exploiting (Halo)
Inf4m0us - Exploiting (Halo)
2PacWorld3 - Exploiting (Halo)
Handguy - Exploiting (Halo)
heiko - Exploiting (Halo)
KRonPaddy - Exploiting (Halo)
Cstaber125 - Exploiting (Halo)
XDman123h - Exploiting (Halo)
LordVrexar - Exploiting (Halo)
Andyslurp2 - Exploiting (Halo)
info135 - Exploiting (Scarfacial)
jooeeeyyyy - Exploiting (Scarfacial)
andyslurp2 - Exploiting (Scarfacial)
Revokz - Exploiting (Scarfacial) Alts: SkilledN00B; zim1337; reterded12113;
Hulk33445 - Posting poison recipe in comments. (Scarfacial)
husnanqas - Annoying me and rulebreaking (Scarfacial)
Unpoke - Exploiting w/ Level 7 exploit (Chiefwaffles)
husqas1 - Hus alt
AFriendlyGuest32 - Hus alt
scardow - Hus alt
chaoman1 - Hus alt
master3411 - Hus alt
davidii2isanoob - Hus alt
kremixslayer - Exploiting (Scarfacial)
chaoman1 - Hus alt (halo)
chaoman2 - Hus alt (halo)
[Ton of hus alts] - Hus alt (Chief)
--]]


local connections = {}
--local iplist = {}
local jails = {}
local teleList = {}
local PersonalTeleports = {}

for i,v in ipairs(workspace.StartupObjects.TeleportWaypoints:GetChildren()) do
	teleList[v.Name] = v.Position
	v.Transparency = 1
end

local GameObjects = game:GetService("ReplicatedStorage").Items

local function lowercase(value)
	if type(value) == "string" then
		return value:lower()
	end
	return ""
end

function findObject(Name, ObjectList)
	if type(Name) ~= 'string' or Name:len() < 1 then
		return {}
	end

	Name = Name:lower()
	ObjectList = type(ObjectList) == 'table' and ObjectList or ObjectList:GetChildren() -- Legacy code

	local Objects = {}
	for _,v in ipairs(ObjectList) do
		local CurrentName = v.Name:lower()
		if CurrentName == Name then
			return {v}
		elseif CurrentName:match( "^" .. Name ) then
			table.insert(Objects, v)
		end
	end

	return Objects
end

function findplayer(name,speaker)
	name = lowercase(name)
	local allPlayers = Players:GetPlayers()
	local chars = {}

	if name == "all" then
		return allPlayers
	elseif name == "me" then
		return {speaker}
	elseif name == "others" then
		for i,v in pairs(allPlayers) do
			if v ~= speaker then
				table.insert(chars, v)
			end
		end
		return chars
	elseif name == "guests" then
		for i,v in pairs(allPlayers) do
			if v.userId < 0 then
				table.insert(chars, v)
			end
		end
		return chars
	elseif name == "admins" then
		for i,_ in pairs(connections) do
			if staffLevel(i) > 0 then
				for _, player in pairs(findObject(i, allPlayers)) do
					table.insert(chars, player)
				end
			end
		end
		return chars
	elseif name == "nonadmins" then
		for i,_ in pairs(connections) do
			if staffLevel(i) == 0 then
				for _, player in pairs(findObject(i, allPlayers)) do
					table.insert(chars, player)
				end
			end
		end
		return chars
	elseif name == "random" then
		return {allPlayers[math.random(1, #allPlayers)]}
	elseif name:find(",") then
		for chunk in name:gmatch("[^,]+") do
			for _,player in pairs(findObject(chunk, allPlayers)) do
				table.insert(chars, player)
			end
		end
		if #chars > 0 then
			return chars
		end
	else
		return findObject(name, allPlayers)
	end
	return false
end

function clampNumber(value, min, max)
	return math.min( math.max(value, min), max)
end

local function GetFormattedTime(Time, ParserValue, Default)
	for i,v in pairs({
		{Name = "year", Value = Time/365/24/60/60},
		{Name = "day", Value = Time/24/60/60},
		{Name = "hour", Value = Time/60/60},
		{Name = "minute", Value = Time/60},
		{Name = "second", Value = Time},
	}) do
		local Value = math.floor(v.Value)
		if Value > 0 then
			return ("%s %s%s %s"):format(Value, v.Name, Value > 1 and "s" or "", ParserValue or "")
		end
	end
	return Default or "now"
end

function chatted(speaker, msg)
	msg = msg:match("^/(.*)")
	
	local command = setmetatable({}, {__index = function(t,i) return rawget(t,i) or "" end})
	for chunk in msg:gmatch("[^ ]+") do
		table.insert(command, chunk)
	end

	-- Public commands

	if lowercase(command[1]) == "store" then
		local hum = speaker.Character:FindFirstChild("Humanoid")

		if hum.Health < hum.MaxHealth * 0.7 then
			SendChat(speaker, "You can't store right now! You've been hurt!")
			return
		end

		if not speaker:findFirstChild("Tools") or not speaker:findFirstChild("Backpack") then return end
		if lowercase(command[2]) == "all" then
			for i,v in pairs(speaker.Backpack:GetChildren()) do
				local OddName = (not (GameObjects:FindFirstChild(v.Name))) or v.Name:find("Resting")
				if DataAccessor.Get(v, "StarterTool") or DataAccessor.Get(v, "Working") or OddName then
					-- This can't be tooled
				else
					v.Parent = speaker:FindFirstChild("Tools")
				end
			end
		else
			local toolName = table.concat(command, " ", 2):gsub("_", " ")
			local tool = unpack(findObject(toolName, speaker.Backpack))
			local OddName = (not (GameObjects:FindFirstChild(tool.Name))) or tool.Name:find("Resting")

			if not tool or DataAccessor.Get(tool, "StarterTool") or DataAccessor.Get(tool, "Working") or OddName then
				return		
			end

			tool.Parent = speaker:FindFirstChild("Tools")
		end
	elseif lowercase(command[1]) == "take" then
		if not speaker:findFirstChild("Tools") or not speaker:findFirstChild("Backpack") then return end
		if lowercase(command[2]) == "all" then
			for i,v in pairs(speaker.Tools:GetChildren()) do
				v.Parent = speaker.Backpack
			end
		else
			local toolName = table.concat(command, " ", 2):gsub("_", " ")
			local tool = unpack(findObject(toolName, speaker.Tools))
			if not tool then return end
			tool.Parent = speaker.Backpack
		end
		
	--[[
	elseif lowercase(command[1]) == "respawn" then
		-- Targeted use is still restricted to Mods+, but everybody can use it to respawn themselves
		if command[2] == '' or command[2] == 'me' then
			speaker:LoadCharacter()
		else
			if staffLevel(speaker.Name) < 1 then
				SendChat(speaker, "You must use the respawn command without a target to respawn your own character.")
			else
				local players = findplayer(command[2],speaker)
				if not players then return end
				for i,v in pairs(players) do
					v:LoadCharacter()
				end				
			end
		end
		--]]
	end
	
	
	
	
	-- Mod commands below this line
if staffLevel(speaker.Name) < 1 then return end
	if lowercase(command[1]) == "ghostlight" then
		ghostlight:FireClient(speaker)
		
	elseif lowercase(command[1]) == "freezestats" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			DataAccessor.Set(v, "Stats.StatsFrozen", true)
		end
	elseif lowercase(command[1]) == "thawstats" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			DataAccessor.Set(v, "Stats.StatsFrozen", false)
		end
	elseif lowercase(command[1]) == "respawn" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			v:LoadCharacter()
		end
	--[[
	elseif lowercase(command[1]) == "mute" then
		local players = findplayer(command[2], speaker)
		local time = tonumber(command[3])
		if not players then return end
		
		local maxTime = staffLevel(speaker.Name) < 3 and staffLevel(speaker.Name) * 5 or 9e300
		
		if not time then
			time = maxTime
		else
			time = math.min(time, maxTime)
		end
		
		local message = table.concat(command, ' ', 4)
		
		if message:len() == 0 then
			message = "You have been muted!"
		end
		
		for _, player in ipairs(players) do
			if not player:FindFirstChild("Muted") and staffLevel(speaker.Name) > staffLevel(player.Name) then
				-- legacy code below, see function Mute near the top of the script
				local mute = Instance.new("BoolValue", player)
				mute.Name = "Muted"
				
				if staffLevel(speaker.Name) < 3 or time then
--					local max = (staffLevel(speaker.Name) < 3) and staffLevel(speaker.Name) * 5 or math.huge
--					time = math.max(time or max, max) --(time or max) <= max and time or max
					game:GetService("Debris"):AddItem(mute, time * 60)
				end
				local Note = table.concat(command, ' ', 4)
					Note = Note ~= '' and Note or "You have been muted!"
				local notification = Instance.new("StringValue")
				notification.Name = (Note and (speaker:findFirstChild("Alias") and speaker.Alias.Value) or speaker.Name) or "StringValue"
				notification.Value = Note 
				notification.Parent = player:FindFirstChild("Chat")
			end
		end
	elseif lowercase(command[1]) == "unmute" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			while v:findFirstChild("Muted") do
				v.Muted:Destroy()
			end
		end
	elseif lowercase(command[1]) == "showall" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			if not v:findFirstChild("ShowAll") then
				local value = Instance.new("BoolValue", v)
				value.Name = "ShowAll"
				value.Value = command[3]:lower() == "true"
			else
				v:findFirstChild("ShowAll").Value = false
			end
		end
	elseif lowercase(command[1]) == "unshowall" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			if v:findFirstChild("ShowAll") then
				v:findFirstChild("ShowAll"):remove()
			end
		end
	--]]
	elseif lowercase(command[1]) == "heal" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			if v.Character and v.Character:findFirstChild("Humanoid") then
				v.Character.Humanoid.Health = v.Character.Humanoid.MaxHealth
			end
		end
	elseif lowercase(command[1]) == "sit" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			if v.Character and v.Character:findFirstChild("Humanoid") then
				v.Character.Humanoid.Sit = true
			end
		end
	elseif lowercase(command[1]) == "removetools" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			v.Tools:ClearAllChildren()
			if v.Character and v.Character:FindFirstChild("Humanoid") then
				v.Character.Humanoid:UnequipTools()
			end
			for _,tool in pairs(v.Backpack:GetChildren()) do
				if not tool:findFirstChild("StarterTool") and not game.StarterPack:FindFirstChild(tool.Name) then
					tool:Destroy()
				end
			end
		end
		--[[
	elseif lowercase(command[1]) == "removeitems" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			v.Pack:ClearAllChildren()
		end
		-]]
	elseif lowercase(command[1]) == "setgrav" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		local basegrav = -clampNumber(tonumber(command[3]) or 0, -1e6, 1e6)
		local grav = 0
		for i,v in pairs(players) do
			if v.Character and v.Character:findFirstChild("Torso") then
				local force = v.Character.Torso:FindFirstChild("BodyForce") or Instance.new("BodyForce", v.Character.Torso)

				for _,part in pairs(v.Character:GetChildren()) do
					if part:IsA("BasePart") then
						grav = grav + part:GetMass() * basegrav
					elseif part:IsA("Hat") then
						if part:findFirstChild("Handle") then
							grav = grav + part.Handle:GetMass() * basegrav
						end
					end
				end
				force.force = Vector3.new(0,grav,0)
			end
		end
	elseif lowercase(command[1]) == "antigrav" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		local basegrav = 140
		local grav = 0
		for i,v in pairs(players) do
			if v.Character and v.Character:findFirstChild("Torso") then
				local force = v.Character.Torso:FindFirstChild("BodyForce") or Instance.new("BodyForce", v.Character.Torso)

				for _,part in pairs(v.Character:GetChildren()) do
					if part:IsA("BasePart") then
						grav = grav + part:GetMass() * basegrav
					elseif part:IsA("Hat") then
						if part:findFirstChild("Handle") then
							grav = grav + part.Handle:GetMass() * basegrav
						end
					end
				end
				force.force = Vector3.new(0,grav,0)
			end
		end
	elseif lowercase(command[1]) == "nograv" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		local basegrav = 196.2
		local grav = 0
		for i,v in pairs(players) do
			if v.Character and v.Character:findFirstChild("Torso") then
				local force = v.Character.Torso:FindFirstChild("BodyForce") or Instance.new("BodyForce", v.Character.Torso)

				for _,part in pairs(v.Character:GetChildren()) do
					if part:IsA("BasePart") then
						grav = grav + part:GetMass() * basegrav
					elseif part:IsA("Hat") then
						if part:findFirstChild("Handle") then
							grav = grav + part.Handle:GetMass() * basegrav
						end
					end
				end
				force.force = Vector3.new(0,grav,0)
			end
		end
	elseif lowercase(command[1]) == "grav" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			if v.Character and v.Character:findFirstChild("Torso") and v.Character.Torso:findFirstChild("BodyForce") then
				v.Character.Torso.BodyForce:remove()
			end
		end
--	elseif lowercase(command[1]) == "walkspeed" then
--		local players = findplayer(command[2],speaker)
--		if not players then return end
--		local speed = clampNumber(tonumber(command[3]) or 16, 10, 10000)
--		for i,v in pairs(players) do
--			if v.Character and v.Character:findFirstChild("Humanoid") then
--				v.Character.Humanoid.WalkSpeed = speed
--			end
--		end
	elseif lowercase(command[1]) == "teleport" or lowercase(command[1]) == "tp" then
		local players = findplayer(command[2],speaker)
		local target = findplayer(command[3],speaker)
		if not players then return end
		if target and #target == 1 then
			for i,v in pairs(players) do
				if v.Character and target[1].Character and target[1].Character:findFirstChild("Torso") then
					IndemnifyTeleport:Fire(v.Character)
					v.Character:MoveTo(target[1].Character.Torso.Position)
				end
			end
		else
			local name = lowercase(command[3]):gsub("island", ""):gsub("%s", "")

			local target;
			for i,v in pairs(teleList) do
				if i:lower():match("|" .. name:lower()) then
					target = v
				end
			end

			if not target then return end
			for i,v in pairs(players) do
				if v.Character then
					IndemnifyTeleport:Fire(v.Character)
					v.Character:MoveTo(target)
				end
			end
		end
	elseif lowercase(command[1]) == "mark" then
		if speaker.Character then
			local Argument = table.concat(command, ' ', 2)
				Argument = Argument ~= '' and Argument or 'DefaultTeleportMarker'
			PersonalTeleports[speaker.Name][Argument] = speaker.Character:GetModelCFrame().p
		end
	elseif lowercase(command[1]) == "recall" then
		local Argument = table.concat(command, ' ', 2)
			Argument = Argument ~= '' and Argument or 'DefaultTeleportMarker'
		if speaker.Character and PersonalTeleports[speaker.Name][Argument] then
			speaker.Character:MoveTo(PersonalTeleports[speaker.Name][Argument])
		end
	elseif lowercase(command[1]) == "kick" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			if staffLevel(speaker.Name) > staffLevel(v.Name) then
				v:Kick("You have been kicked from this server.")
			end
		end
	elseif lowercase(command[1]) == "ban" then
		local players = findplayer(command[2],speaker)
		local Reason = table.concat(command, " ", 3)

		if not ProductionServer then
			for i,v in pairs(players) do
				v:Kick("You have been kicked from this server.")
			end
			SendChat(speaker, "Ban request failed - Bans can only be issued on production servers.")
			return
		end

		for i,v in pairs(players) do
			if staffLevel(speaker.Name) > staffLevel(v.Name) then
				Ban(v, Reason)
			end
		end
	elseif lowercase(command[1]) == "invisible" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			if v.Character then
				for _,part in pairs(v.Character:GetChildren()) do
					if part:IsA("BasePart") then
						part.Transparency = 1
					elseif part:IsA("Hat") and part:findFirstChild("Handle") then
						part.Handle.Transparency = 1
					end
				end
				if v.Character.Head ~= nil and v.Character.Head.face ~= nil then
					v.Character.Head.face.Transparency = 1
				end
			end
		end
	elseif lowercase(command[1]) == "visible" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			if v.Character then
				for _,part in pairs(v.Character:GetChildren()) do
					if part:IsA("BasePart") and part.Name ~= 'HumanoidRootPart' then
						part.Transparency = 0
					elseif part:IsA("Hat") and part:findFirstChild("Handle") then
						part.Handle.Transparency = 0
					end
				end
			end
		end
	elseif lowercase(command[1]) == "freeze" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			if v.Character then
				for _,part in pairs(v.Character:GetChildren()) do
					if part:IsA("BasePart") then
						part.Anchored = true
						part.Reflectance = .3
					elseif part:IsA("Humanoid") then
						local speed = Instance.new("NumberValue", part)
						speed.Name = "StoredWalkSpeed"
						speed.Value = part.WalkSpeed
						part.WalkSpeed = 0
					end
				end
			end
		end
	elseif lowercase(command[1]) == "thaw" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			if v.Character then
				for _,part in pairs(v.Character:GetChildren()) do
					if part:IsA("BasePart") then
						part.Anchored = false
						part.Reflectance = 0
					elseif part:IsA("Humanoid") then
						if part:findFirstChild("StoredWalkSpeed") then
							part.WalkSpeed = part.StoredWalkSpeed.Value
							part.StoredWalkSpeed:remove()
						else
							part.WalkSpeed = 16
						end
					end
				end
			end
		end
		--[[
	elseif lowercase(command[1]) == "warn" or lowercase(command[1]) == "notify" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			if v:findFirstChild("Chat")then
				local notification = Instance.new("StringValue")
				notification.Name = speaker:findFirstChild("Alias") and speaker.Alias.Value or speaker.Name
				notification.Value = table.concat(command, " ", 3)
				notification.Parent = v.Chat
			end
		end
		--]]
	elseif lowercase(command[1]) == "change" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			local stats = v.Data:findFirstChild("Stats")
			if not stats then return end
			local changeTo = tonumber(command[4]) or 0
			for _,stat in pairs(findObject(command[3], stats)) do
				stat.Value = changeTo
			end
		end
		--[[
	elseif lowercase(command[1]) == "shipheight" then
		-- idk
		local seat = speaker.Character and speaker.Character:FindFirstChild("Humanoid") and speaker.Character:FindFirstChild("Humanoid").SeatPart
		local height = tonumber(command[2]) or 25
		
		if seat and height then
			local bodyPos = seat.Parent:FindFirstChild("MainPart") and seat.Parent:FindFirstChild("MainPart"):FindFirstChild("BodyPosition")
			
			if bodyPos then
				bodyPos.position = Vector3.new(0, height, 0)
			end
		end]]
	end
	
	--Admin only commands below this line
	if staffLevel(speaker.Name) < 2 then return end
	
	if lowercase(command[1]) == "kill" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			if v.Character then
				v.Character:BreakJoints()
			end
		end
		--[[
	elseif lowercase(command[1]) == "health" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		local health = clampNumber(tonumber(command[3]) or 100, 0, math.huge)
		for i,v in pairs(players) do
			if v.Character and v.Character:findFirstChild("Humanoid") then
				v.Character.Humanoid.MaxHealth = health
				v.Character.Humanoid.Health = health
			end
		end
		--]]
	elseif lowercase(command[1]) == "damage" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		local damage = clampNumber(tonumber(command[3]) or 0, 0, math.huge)
		for i,v in pairs(players) do
			if v.Character and v.Character:findFirstChild("Humanoid") then
				v.Character.Humanoid:takeDamage(damage)
			end
		end
	elseif lowercase(command[1]) == "ff" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			if v.Character then
				local ff = Instance.new("ForceField")
				ff.Name = "Admin ForceField"
				ff.Parent = v.Character
			end
		end
	elseif lowercase(command[1]) == "unff" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			if v.Character then
				for _,part in pairs(v.Character:GetChildren()) do
					if part:IsA("ForceField") then
						part:remove()
					end
				end
			end
		end
	elseif lowercase(command[1]) == "sparkles" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			local torso = v.Character and v.Character:findFirstChild("Torso")
			if torso and not torso:FindFirstChild("Sparkles") then
				local sparkles = Instance.new("Sparkles", torso)
				sparkles.Color = Color3.new(math.random(1,255)/255,math.random(1,255)/255,math.random(1,255)/255)
			end
		end
	elseif lowercase(command[1]) == "unsparkles" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			if v.Character and v.Character:findFirstChild("Torso") then
				for _,part in pairs(v.Character.Torso:GetChildren()) do
					if part:IsA("Sparkles") then
						part:remove()
					end
				end
			end
		end
	elseif lowercase(command[1]) == "jump" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			if v.Character and v.Character:findFirstChild("Humanoid") then
				v.Character.Humanoid.Jump = true
			end
		end
	elseif lowercase(command[1]) == "stand" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			if v.Character and v.Character:findFirstChild("Humanoid") then
				v.Character.Humanoid.Sit = false
			end
		end
		
		--[[
	elseif lowercase(command[1]) == "givebtools" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		local flag;
		for i,v in pairs(players) do
			if staffLevel(v.Name) > 0 or staffLevel(speaker.Name) == 3 then
				local Wand = Instance.new("HopperBin")
				Instance.new("BoolValue", Wand).Name = "AdminTool"
				Wand.BinType = "Clone"
				Wand.Parent = v.Backpack
				local Hammer = Instance.new("HopperBin")
				Instance.new("BoolValue", Hammer).Name = "AdminTool"
				Hammer.BinType = "Hammer"
				Hammer.Parent = v.Backpack
			else
				flag = true
			end
		end
		
		if flag then
			SendChat(speaker, "You cannot give btools to non-staff players.")
		end
		]]
		
		
	elseif lowercase(command[1]) == "time" then
		game.Lighting.TimeOfDay = ("%d:%d:%d"):format(tonumber(command[2]) or 0, tonumber(command[3]) or 0, tonumber(command[4]) or 0)
		
		
	elseif lowercase(command[1]) == "trip" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			if v.Character and v.Character:findFirstChild("Torso") then
				v.Character.Torso.CFrame = v.Character.Torso.CFrame * CFrame.Angles(math.pi,0,0)
			end
		end
	elseif lowercase(command[1]) == "give" then
		local players = findplayer(command[2],speaker)
		local num = tonumber(command[#command])
		local objectName;
		if num then
			num = clampNumber(num, 1, 20)
			objectName = table.concat(command, ' ', 3, #command - 1)
		else
			num = 1
			objectName = table.concat(command, ' ', 3)
		end

		local Objects = findObject(objectName, GameObjects)

		if #Objects < 1 or not players then
			return
		end

		for i,v in pairs(players) do
			for _,tool in pairs(Objects) do
				for i=1, num do
					local tool = tool:Clone()
					tool.Parent = tool:IsA("BasePart") and game.ReplicatedStorage.StarterTools.Inventory.Inventories[tostring(v.UserId)] or v.Backpack
				end
			end
		end
	end

	if staffLevel(speaker.Name) < 3 then return end
	-- Editor only commands below this line

	if lowercase(command[1]) == "seen" and ProductionServer then
		local userId = tonumber(command[2])
		if userId then
			local last_login = AdminTracker:GetAsync(userId)
			if last_login then
				SendChat(speaker, ("%s last seen: %s"):format(userId, GetFormattedTime(math.floor(tick()) - last_login, "ago", "never")))
			else
				SendChat(speaker, ("No record for userid %s"):format(userId) )
			end
		else
			SendChat(speaker, "Invalid parameter - Use ::seen/<userid>")
		end
	end

	if lowercase(command[1]) == "alias" then
		local name = command[2]
		local alias = speaker:findFirstChild("Alias")
		if alias and (not name or name == "clear") then
			alias:remove()
			return
		elseif not alias then
			alias = Instance.new("StringValue", speaker)
			alias.Name = "Alias"
		end
		alias.Value = name
	end

	if lowercase(command[1]) == "weather" or lowercase(command[1]) == "storm" then
		game.Workspace.WeatherScript.Active.Value = lowercase(command[2]) == "on"
	end
--[[
	if lowercase(command[1]) == "c" then
		local func, comperr = loadstring(msg:sub(3))
		if func then
			local status, rterr = pcall(func)
			if not status then
				SendChat(speaker, "Runtime error: " .. rterr)
			end
		else
			SendChat(speaker, "Compilation error: " .. comperr)
		end
	end

	if lowercase(command[1]) == "devmode" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			if not v:findFirstChild("DevMode") then
				Instance.new("BoolValue", v).Name = "DevMode"
			end
		end
	end

	if lowercase(command[1]) == "undevmode" then
		local players = findplayer(command[2],speaker)
		if not players then return end
		for i,v in pairs(players) do
			if v:findFirstChild("DevMode") then
				v.DevMode:remove()
			end
		end
	end
	--]]
	if lowercase(command[1]) == "shutdown" and lowercase(command[2]) == "server" then -- Shutdown/server, just to make sure you actually want to do it.
		for i,v in pairs(Players:GetPlayers()) do v:Destroy() end
		Players.PlayerAdded:connect(function(player) player:Kick("Server shut down.") end)
		Instance.new("Message", game.Workspace).Text = "This server has been shut down by an editor."
	end--[[

	if lowercase(command[1]) == "sudo" then
		local Target = unpack(findplayer(command[2],speaker))
		if Target and staffLevel(Target.Name) < staffLevel(speaker.Name) then
			table.remove(command, 2)
			table.remove(command, 1)

			if #command > 0 then
				pcall(chatted, Target, table.concat(command,"/"))
			end
		end
	end
	--]]
end

function playerAdded(player)
	if not VIPServer then
		--[[
		PopulateBanlist()
		for i,v in pairs(Players:GetPlayers()) do
			if (bannedlist[v.Name:lower()] or bannedlist[v.userId]) then
				TeleportService:Teleport(152768891, v) -- Hehehehe
--				v:Kick("You are banned.") -- Backup solution
				return
			end
		end
		--]]
	end
	
	Instance.new("Folder", player).Name = "Tools"

	if staffLevel(player.Name) > 0 and ProductionServer then
		AdminTracker:SetAsync(player.userId, math.floor(os.time()))
	end
	PersonalTeleports[player.Name] = PersonalTeleports[player.Name] or {}
	
	local banned, reason = IsBanned(player)
	
	if banned and not VIPServer then
		player:Kick("You are banned: "..reason)
	end
	
	player.Chatted:connect(function(message)
		pcall(chatted, player, message)
	end)
end

Players.PlayerAdded:connect(playerAdded)

-- Client/Server communication
game.ReplicatedStorage.Commands.GetStaffRank.OnServerInvoke = function(RequestingPlayer, Name)
	if type(Name) == 'string' then
		return staffLevel(Name)
	else
		local Success, Rank = pcall(staffLevel, RequestingPlayer.Name)
		if Success then
			return Rank
		else
			return 0
		end
	end
end

game.ReplicatedStorage.Commands.GetAdminList.OnServerInvoke = function(RequestingPlayer, Name)
	return {
		editorlist;
		juniorEditors;
		adminlist;
		modlist;
	}
end
