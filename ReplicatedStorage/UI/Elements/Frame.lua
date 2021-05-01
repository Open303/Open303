local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local Create = Load "Create"
local Element = Load "UI.Elements.Element"

local Frame = {}
setmetatable(Frame, { __index = Element })
Frame.ClassName = "Frame"
Frame.__index = Element.__index
Frame.__newindex = Element.__newindex

function Frame.new()
	local robloxObject = Create "Frame" {
		Name = "Frame";
		BackgroundColor3 = Color3.new(1, 1, 1);
		BorderSizePixel = 0;
	}
	
	local self = setmetatable(Element.new(robloxObject), Frame)
	return self
end

return Frame