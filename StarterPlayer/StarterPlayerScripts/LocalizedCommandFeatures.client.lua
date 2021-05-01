---pre-reqs---

local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local localPlayer = game.Players.LocalPlayer

---events---

local ghostlight = Load "Commands.GhostlightToggle"

---happenings---

ghostlight.OnClientEvent:connect(function()
	local existinglight = localPlayer.Character.Head:FindFirstChild("PointLight")
	if existinglight == nil then
		local light = Instance.new("PointLight", localPlayer.Character.Head)
		light.Brightness = 1
		light.Range = 60
	else
		existinglight:destroy()
	end
end)