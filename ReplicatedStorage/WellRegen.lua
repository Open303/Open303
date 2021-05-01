--[[
	This is a substitute for the LinkedSource "WellRegen" script.
	I've pretty much just dropped the script into a function and this module returns that function.
]]--

local module = function(callingScript)
	local MAX_LEVEL = 50
	local SECONDS_PER_FILL = 30
	if game:GetService("RunService"):IsStudio() then
		SECONDS_PER_FILL = 1
	end
	
	local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
	local DataAccessor = Load "Data.DataAccessor"
	
	local well = callingScript.Parent
	local water = well:WaitForChild("Water")
	local amountValue do
	    DataAccessor.Set(water, "Edible.Portions", 0)
	    amountValue = DataAccessor.GetStoringObject(water, "Edible.Portions")
	end
	
	local function GetTransparency()
	    return amountValue.Value <= 0 and 1 or 0.5
	end
	
	local function FillWell()
	    local current = DataAccessor.Get(water, "Edible.Portions")
	    local new = math.min(current + 1, MAX_LEVEL)
	    DataAccessor.Set(water, "Edible.Portions", new)
	end
	
	amountValue.Changed:connect(function()
	    water.Transparency = GetTransparency()
	end)
	
	while true do
	    wait(SECONDS_PER_FILL)
	    FillWell()
	end
end

return module
