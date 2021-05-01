local part1 = script.Parent:WaitForChild("Door_Tele")
local part2 = script.Parent:WaitForChild("Hatch_Tele")
local part3 = script.Parent:WaitForChild("Tele_Part")
local debounce

local requiredOffset = part1.CFrame:pointToObjectSpace(part2.CFrame.p)

local IndemnifyTeleport = game:GetService("ServerScriptService").AntiExploit.IndemnifyTeleport

part1.Touched:connect(function(hit)
	if (part1.CFrame:pointToObjectSpace(part2.CFrame.p) - requiredOffset).magnitude > 0.5 then return end
	
	local player = game.Players:GetPlayerFromCharacter(hit.Parent) or game.Players:GetPlayerFromCharacter(hit.Parent.Parent)
	if debounce or not player then return end
	debounce = true
	IndemnifyTeleport:Fire(player.Character)
	player.Character:SetPrimaryPartCFrame(part2.CFrame + Vector3.new(0, 3.5, 0))
--	player.Character:MoveTo(part2.Position + Vector3.new(0,3.5, 0))
	wait(2)
	debounce = false
end)

part2.Touched:connect(function(hit)
	if (part1.CFrame:pointToObjectSpace(part2.CFrame.p) - requiredOffset).magnitude > 0.5 then return end
	
	local player = game.Players:GetPlayerFromCharacter(hit.Parent) or game.Players:GetPlayerFromCharacter(hit.Parent.Parent)
	if debounce or not player then return end
	debounce = true
	IndemnifyTeleport:Fire(player.Character)
	player.Character:SetPrimaryPartCFrame(part3.CFrame + Vector3.new(0, 3.5, 0))
--	player.Character:MoveTo(part3.Position + Vector3.new(0,3.5, 0))
	wait(2)
	debounce = false
end)
