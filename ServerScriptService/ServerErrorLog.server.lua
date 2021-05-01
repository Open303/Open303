-- Logs errors to a Discord channel.

----------------------------------------
----- Constants ------------------------
----------------------------------------
-- ID of the channel to send to.
local CHANNEL_ID = "211498743596318724"
-- The bot account's token.
local BOT_TOKEN = "MjAzOTc4NDgxNzc0NzU1ODQx.CmxE_g.tWAoyLR_5T3CsnNV8Gt_c3R_eN8"
-- The API URL to send to.
local API_URL = "https://discordapp.com/api/channels/"..CHANNEL_ID.."/messages"
-- Use at most 100 HttpService requests per minute.
local REQUEST_ALLOWANCE = 100
-- How long a request will be considered 'active', that is, counting towards the request allowance.
-- Should be kept at 60 seconds for optimal results with HttpService timing.
local REQUEST_LIFETIME = 60
-- Whether to log in Studio or not. If false, errors will be silently dropped (and presumably printed to output).
local LOG_IN_STUDIO = false

local IGNORE_PATTERNS = {
	"FakeEgghuntEgg%.Handle%.awarder";
	"ChatScript";
}

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))

----------------------------------------
----- Objects --------------------------
----------------------------------------
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ScriptContextService = game:GetService("ScriptContext")

local remoteClientError = Load "ErrorLogging.ClientError"

----------------------------------------
----- Variables ------------------------
----------------------------------------
local headers = {
	Authorization = "Bot "..BOT_TOKEN;
}

local queue = {}
local usedRequests = 0
local loggedMessages = {}

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function GetEnvironment()
	if game.PlaceId == 480485987 then
		return "Production"
	elseif game.PlaceId == 707686333 then
		return "Mem's Test"
	end
end

local function SendMessage(messageBody)
	if RunService:IsStudio() and not LOG_IN_STUDIO then
		return
	end
	
	pcall(HttpService.PostAsync, HttpService, API_URL, HttpService:JSONEncode({ content = messageBody }), Enum.HttpContentType.ApplicationJson, false, headers)
end

local function FormatError(errorTable)
	local envString = GetEnvironment()
	
	local parts = {}
	
	if envString ~= nil then
		table.insert(parts, "**From ")
		table.insert(parts, envString)
		table.insert(parts, "**\n")
	end
	
	table.insert(parts, "**")
	table.insert(parts,  errorTable.Message)
	table.insert(parts, "**\n")
	table.insert(parts, errorTable.StackTrace)
	table.insert(parts, "\n")
	table.insert(parts, "**Source**: ")
	table.insert(parts, errorTable.Source)
	
	if errorTable.Player then
		table.insert(parts, "\n")
		table.insert(parts, "**Player**: ")
		table.insert(parts, errorTable.Player.Name)
		table.insert(parts, "(user ID: ")
		table.insert(parts, errorTable.Player.UserId)
		table.insert(parts, ")")
	end
	
	return table.concat(parts, "")
end

local function AdvanceQueue()
	local current = queue[1]
	table.remove(queue, 1)

	while usedRequests > REQUEST_ALLOWANCE do
		wait(1)
	end
	
	local message = FormatError(current)
	SendMessage(message)
	usedRequests = usedRequests + 1
	
	delay(REQUEST_LIFETIME, function()
		usedRequests = usedRequests - 1
	end)
end

local function PushToQueue(errorTable)
	for _, ignore in ipairs(IGNORE_PATTERNS) do
		if errorTable.Message:match(ignore) ~= nil then
			return
		end
		
		if errorTable.StackTrace:match(ignore) ~= nil then
			return
		end
		
		if errorTable.Object:match(ignore) ~= nil then
			return
		end
	end
	
	if loggedMessages[errorTable.Message] then
		return
	end
	
	loggedMessages[errorTable.Message] = true
	table.insert(queue, errorTable)
end

local function OnServerError(message, trace, source)
	local success, fullName = pcall(game.GetFullName, source)
	if not success then
		fullName = "**unknown**"
	end
	
	PushToQueue({
		Message = message;
		StackTrace = trace;
		Object = fullName;
		Source = "Server";
	})
end

local function OnClientError(player, message, trace, source)
	PushToQueue({
		Message = message;
		StackTrace = trace;
		Object = source;
		Source = "Client";
		Player = player;
	})
end

----------------------------------------
----- Main Script ----------------------
----------------------------------------
ScriptContextService.Error:connect(OnServerError)
remoteClientError.OnServerEvent:connect(OnClientError)

while wait(1) do
	if #queue > 0 then
		while #queue > 0 do
			AdvanceQueue()
		end
	end
end