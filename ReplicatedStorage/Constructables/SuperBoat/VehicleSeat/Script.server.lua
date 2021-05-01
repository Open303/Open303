script.Parent.Changed:Connect(function(property)
	if property == "Occupant" then
		local humanoid = script.Parent.Occupant
		
		if humanoid ~= nil then
			script.Parent.MaxSpeed = humanoid.WalkSpeed
		end
	end
end)
