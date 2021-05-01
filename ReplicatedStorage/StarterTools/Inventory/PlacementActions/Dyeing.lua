local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"

return {
	UsableOn = function(player, selectedItem, part)
		if part.Locked then return false end
		if not DataAccessor.Get(part, "Dyeable") then return false end
		if part.BrickColor == selectedItem.BrickColor then return false end
		return true
	end;
	
	GetHint = function(player, selectedItem)
		return "Click a highlighted object to dye it."
	end;
	
	Act = function(player, selectedItem, part)
		part.BrickColor = selectedItem.BrickColor
		selectedItem:Destroy()
	end;
}