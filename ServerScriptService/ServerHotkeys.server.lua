----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local HotkeyDefinitions = Load "Hotkeys.HotkeyDefinitions"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local DataStoreService = game:GetService("DataStoreService")

local remoteGetHotkeyMap = Load "Hotkeys.GetHotkeyMap"
local remoteHotkeyChanged = Load "Hotkeys.HotkeyChanged"

----------------------------------------
----- Variables ------------------------
----------------------------------------
local hotkeyDatastore = DataStoreService:GetDataStore("Hotkeys", "Survival303")

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function GetHotkeysForPlayer(player)
	local key = "Hotkeys-"..tostring(player.UserId)
	local success, differingHotkeys = pcall(hotkeyDatastore.GetAsync, hotkeyDatastore, key)
	
	if not success then
		warn("Error retrieving values from data store: "..differingHotkeys)
		return {}
	elseif differingHotkeys == nil then
		return {}
	end
	
	local returnedData = {}
	
	for id, keyCodeName in pairs(differingHotkeys) do
		table.insert(returnedData, {
			Id = id;
			Code = keyCodeName;
		})
	end
	
	return returnedData
end

local function OnHotkeyRebound(player, id, newBindingName)
	local success, message = pcall(hotkeyDatastore.UpdateAsync, hotkeyDatastore, "Hotkeys-"..tostring(player.UserId), function(old)
		if old == nil then
			old = {}
		end
		
		old[id] = newBindingName;
		return old
	end)
	
	if not success then
		warn("Error saving hotkey "..id.." (code: "..newBindingName..") for player "..player.UserId.." (name: "..player.Name.."): "..message)
	end
end

----------------------------------------
----- Server Hotkeys -------------------
----------------------------------------
remoteGetHotkeyMap.OnServerInvoke = GetHotkeysForPlayer
remoteHotkeyChanged.OnServerEvent:connect(OnHotkeyRebound)