-- Region checks - e.g. NoPlace and so on

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))

----------------------------------------
----- Regions --------------------------
----------------------------------------
local Regions = {}

function Regions.IsPointInPart(point, part)
	local halfSize = part.Size / 2
	-- yay floating point rounding
	halfSize = halfSize + Vector3.new(0.5, 0.5, 0.5)
	local objectSpace = part.CFrame:pointToObjectSpace(point)
	
	return objectSpace.X >= -halfSize.X and objectSpace.X <= halfSize.X 
		and objectSpace.Y >= -halfSize.Y and objectSpace.Y <= halfSize.Y 
		and objectSpace.Z >= -halfSize.Z and objectSpace.Z <= halfSize.Z
end

function Regions.IsPointInRegion(point, regionName)
	local bin = Load("Regions."..regionName, workspace)
	
	for _, child in ipairs(bin:GetChildren()) do
		if Regions.IsPointInPart(point, child) then
			--print(point, "is in", regionName, "intersects", child:GetFullName())
			return true
		end
	end
	
	return false
end

return Regions