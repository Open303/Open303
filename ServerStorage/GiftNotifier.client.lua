local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local notif = Load "HolidayItems.NotifyPlayer"
local StarterGui = game:GetService("StarterGui")

local localPlayer = game.Players.LocalPlayer



-----------

notif.OnClientEvent:connect(function(giftinfo)
	StarterGui:SetCore("ChatMakeSystemMessage", {
				Text = ""..giftinfo.."";
				Color = Color3.new(1, 1, 0);
			})
end)