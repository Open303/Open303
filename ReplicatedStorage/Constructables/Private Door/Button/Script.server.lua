local door = script.Parent.Parent.Door 

script.Parent.Touched:connect(function()
	door.Transparency = 0.5 
	door.CanCollide = false 

	wait(2) 

	door.Transparency = 0 
	door.CanCollide = true 
end)