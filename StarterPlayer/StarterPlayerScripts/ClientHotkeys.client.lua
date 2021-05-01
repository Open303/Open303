----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))

----------------------------------------
----- Objects --------------------------
----------------------------------------
local UserInputService = game:GetService("UserInputService")

local remoteGetHotkeyMap = Load "Hotkeys.GetHotkeyMap"
local remoteHotkeyChanged = Load "Hotkeys.HotkeyChanged"

local bindableGetHotkeys = Load "Hotkeys.Interactions.GetHotkeys"
local bindableIsHotkeyDown = Load "Hotkeys.Interactions.IsHotkeyDown"
local bindableRebindHotkey = Load "Hotkeys.Interactions.RebindHotkey"
local bindableResetHotkey = Load "Hotkeys.Interactions.ResetHotkey"
local bindableHotkeyRebound = Load "Hotkeys.Interactions.HotkeyRebound"
local bindableHotkeyPressed = Load "Hotkeys.Interactions.HotkeyPressed"
local bindableHotkeyReleased = Load "Hotkeys.Interactions.HotkeyReleased"

----------------------------------------
----- Variables ------------------------
----------------------------------------
local hotkeyMap = Load "Hotkeys.HotkeyDefinitions"

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function GetKeyCode(id)
	local entry = hotkeyMap[id]
	return entry.Key or entry.Default
end

local function IsHotkeyDown(id)
	return UserInputService:IsKeyDown(GetKeyCode(id))
end

local function RebindHotkey(id, newBinding, forceRebind)
	local isDifferent = GetKeyCode(id) ~= newBinding
	
	if isDifferent or forceRebind then
		if IsHotkeyDown(id) then
			bindableHotkeyReleased:Fire(id)
		end
		
		hotkeyMap[id].Key = newBinding
		bindableHotkeyRebound:Fire(id, newBinding)
		remoteHotkeyChanged:FireServer(id, newBinding.Name)
	end
end

local function ResetHotkey(id)
	RebindHotkey(id, hotkeyMap[id].Default, true)
end

----------------------------------------
----- Event Listeners ------------------
----------------------------------------
local function MakeInputListener(eventObject)
	return function(inputObject, gameProcessed)
		if gameProcessed then return end
	
		if inputObject.UserInputType == Enum.UserInputType.Keyboard then
			for id, binding in pairs(hotkeyMap) do
				local bindingKey = GetKeyCode(id)
				if bindingKey == inputObject.KeyCode then
				--	print("[ClientHotkeys] ~ Hotkey ID "..id.." matches KeyCode "..inputObject.KeyCode.Name..".")
					eventObject:Fire(id)
				end
			end
		end
	end
end

----------------------------------------
----- Client Hotkeys -------------------
----------------------------------------
UserInputService.InputBegan:connect(MakeInputListener(bindableHotkeyPressed))
UserInputService.InputEnded:connect(MakeInputListener(bindableHotkeyReleased))

bindableIsHotkeyDown.OnInvoke = IsHotkeyDown
bindableRebindHotkey.OnInvoke = RebindHotkey
bindableResetHotkey.OnInvoke = ResetHotkey
bindableGetHotkeys.OnInvoke = function() return hotkeyMap end

for _, hotkeyInfo in ipairs(remoteGetHotkeyMap:InvokeServer()) do
	local id = hotkeyInfo.Id
	local code = hotkeyInfo.Code
	hotkeyMap[id].Key = code
end