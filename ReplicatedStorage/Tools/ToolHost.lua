--[[
	This is a substitute for the LinkedSource "ToolHost" script.
	I've pretty much just dropped the script into a function and this module returns that function.
]]--

local function module(callingScript)
	local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
	local DataAccessor = Load "Data.DataAccessor"
	
	local toolObject = callingScript.Parent
	local toolClass = DataAccessor.GetStoringObject(toolObject, "Tool.Class").Value
	
	local toolModule = Load("Tools."..toolClass..".Tool"..toolClass)
	toolModule.new(toolObject)
end

return module