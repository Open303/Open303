local door = script.Parent.Parent.Door 

script.Parent.Touched:connect(function(hit)
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if not player then return end

	door.Transparency = 0.5 
	door.CanCollide = false 

	wait(1) 

	door.Transparency = 0 
	door.CanCollide = true 
end)