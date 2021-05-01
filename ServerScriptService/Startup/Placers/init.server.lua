----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local constructablesBin = Load "Constructables"
local itemBin = Load "Items"
local placementTool = script.PlacementTool

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function MakePlacementTool(constructable)
	local tool = placementTool:Clone()
	tool.Name = constructable.Name
	tool.Parent = itemBin
end

----------------------------------------
----- Placers --------------------------
----------------------------------------
for _, constructable in ipairs(constructablesBin:GetChildren()) do
	MakePlacementTool(constructable)
end