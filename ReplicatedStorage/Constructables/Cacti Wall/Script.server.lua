wait(10)

for i,v in pairs(script.Parent:GetChildren()) do
	if v.Name == "Cacti" then
		v.Touched:connect(function(hit)
			-- old code that apparently didn't work
			--[[local player = game.Players:GetPlayerFromCharacter(hit.Parent) or game.Players:GetPlayerFromCharacter(hit.Parent.Parent)
			if not player then return end
			player.Character.Humanoid:TakeDamage(5)]]
			local humanoid = hit.Parent:FindFirstChild("Humanoid") or hit.Parent.Parent:FindFirstChild("Humanoid")
			
			if humanoid then
				humanoid:TakeDamage(5)
			end
		end)
	end
end