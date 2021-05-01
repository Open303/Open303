local PlayerCharacter = {}

function PlayerCharacter.GetEquippedTool(player)
	local character = player.Character
	
	if character ~= nil then
		for _, child in ipairs(character:GetChildren()) do
			if child:IsA("Tool") then
				return child
			end
		end
	end
	
	return nil
end

function PlayerCharacter.GetHumanoid(player)
	local character = player.Character
	
	if character ~= nil then
		return character:FindFirstChild("Humanoid")
	end
	
	return nil
end

function PlayerCharacter.IsAlive(player)
	local humanoid = PlayerCharacter.GetHumanoid(player)
	
	if humanoid ~= nil and humanoid.Health > 0 then
		return true
	end
	
	return false
end

function PlayerCharacter.GetHumanoidFromPart(part)
	local level = part
	
	while true do
		local humanoid = level:FindFirstChild("Humanoid")
		
		if humanoid ~= nil then
			return humanoid
		else
			level = level.Parent
			
			if level == nil or level == workspace then
				break
			end
		end
	end
	
	return nil
end

function PlayerCharacter.WaitForCurrentHumanoid(player)
	while true do
		local character = player.Character
		
		if character == nil or 
			not character:IsDescendantOf(workspace) or 
			character:FindFirstChild("Humanoid") == nil or 
			character:FindFirstChild("Humanoid").Health <= 0 then
			
			wait(0)
		else
			break
		end
	end
	
	local character = player.Character
	return character:WaitForChild("Humanoid")
end

return PlayerCharacter