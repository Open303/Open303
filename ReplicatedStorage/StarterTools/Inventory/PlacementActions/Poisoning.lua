local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"

local function IsPoisonable(item)
	local edible = DataAccessor.Get(item, "Edible")
	return edible ~= nil and edible.Poison == 0
end

return {
	UsableOn = function(player, selectedItem, part)
		return IsPoisonable(part)
	end;
	
	GetHint = function(player, selectedItem)
		return "Click a highlighted object to poison it."
	end;
	
	Act = function(player, selectedItem, part)
		DataAccessor.Set(part, "Edible.Poison", DataAccessor.Get(selectedItem, "PoisonValue"))
		selectedItem:Destroy()
	end;
}