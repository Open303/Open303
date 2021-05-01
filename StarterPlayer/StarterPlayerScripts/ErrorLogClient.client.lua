-- Local proxy for error logging.

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))

----------------------------------------
----- Objects --------------------------
----------------------------------------
local ScriptContextService = game:GetService("ScriptContext")

local remoteClientError = Load "ErrorLogging.ClientError"

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function OnError(message, trace, source)
	if not source then return end
	-- if the CoreScripts error we get an error trying to get the source's full name
	local success, fullName = pcall(game.GetFullName, source)
	if not success then return end
	remoteClientError:FireServer(message, trace, fullName)
end

----------------------------------------
----- Main Script ----------------------
----------------------------------------
ScriptContextService.Error:connect(OnError)