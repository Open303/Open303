local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"

local plantModels = Load "Plants"

local function GetResult(seed, soil)
	local nameModels = plantModels:FindFirstChild(soil.Name)
	
	if not nameModels then
		return nil
	end
	
	return nameModels:FindFirstChild(DataAccessor.Get(seed, "Crop.Result"))
end

return {
	UsableOn = function(player, selectedItem, part)
		return GetResult(selectedItem, part) ~= nil and not part.Locked
	end;
	
	GetHint = function(player, selectedItem)
		local compostName = DataAccessor.Get(selectedItem, "Crop.RequiredSoil")
		return "Click a highlighted object to plant the "..selectedItem.Name
	end;
	
	Act = function(player, selectedItem, part)
		local crop = DataAccessor.Get(selectedItem, "Crop.Result")
		local growthTime = DataAccessor.Get(selectedItem, "Crop.GrowthTime")
		local model = GetResult(selectedItem, part):Clone()
		
		local wasLocked = part.Locked
		part.Locked = true
		selectedItem.Parent = workspace
		selectedItem.Anchored = true
		selectedItem.CanCollide = false
		selectedItem.CFrame = part.CFrame * CFrame.new(0, part.Size.Y / 2, 0)
		selectedItem.Locked = true
		selectedItem:BreakJoints()
		
		local multiplier = game.ReplicatedStorage.ConfigValues.GrowthMultiplier.Value		
		
		local variance = math.min(growthTime / 2, 30)
		
		wait((growthTime + math.random(-variance, variance)) * multiplier)
		
		part.Locked = wasLocked
		selectedItem:Destroy()
		
		model.Parent = workspace
		model:MoveTo(part.Position)
		model:MakeJoints()
		wait(.1)
		if model:FindFirstChild("Benign") then
			model.Benign.Disabled = false
		end
	end;
}