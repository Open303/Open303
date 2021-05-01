----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local Tool = Load "Tools.Tool"
local SharedOilFilter = Load "Tools.OilFilter.SharedOilFilter"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local localPlayer = game.Players.LocalPlayer

local remoteOilProcessAttempt = Load "Tools.OilFilter.OilProcessAttempt"

----------------------------------------
----- Oil Filter Tool ------------------
----------------------------------------
local ToolOilFilter = {}
ToolOilFilter.__index = ToolOilFilter
setmetatable(ToolOilFilter, Tool)

function ToolOilFilter.new(tool)
	local self = setmetatable(Tool.new(tool), ToolOilFilter)
	return self
end

function ToolOilFilter:OnActivated(mouse)
	local target = mouse.Target
	local point = mouse.Hit.p
	
	if SharedOilFilter.CanFilter(localPlayer, target, point) then
		remoteOilProcessAttempt:FireServer(target, point)
		return true, DataAccessor.Get(self.Object, "Tool.FilterTime")
	end
	
	return false
end

function ToolOilFilter:IsInteractable(part, point)
	return SharedOilFilter.CanFilter(localPlayer, part, point)
end

return ToolOilFilter