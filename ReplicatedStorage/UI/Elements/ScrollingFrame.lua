local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local Create = Load "Create"
local Element = Load "UI.Elements.Element"

local ScrollingFrame = {}
setmetatable(ScrollingFrame, { __index = Element })
ScrollingFrame.ClassName = "ScrollingFrame"
ScrollingFrame.__index = Element.__index
ScrollingFrame.__newindex = Element.__newindex

function ScrollingFrame.new()
	local robloxObject = Create "ScrollingFrame" {
		Name = "ScrollingFrame";
		BackgroundColor3 = Color3.new(1, 1, 1);
		BorderSizePixel = 0;
	}
	
	local self = setmetatable(Element.new(robloxObject), ScrollingFrame)
	return self
end

Element._forward(ScrollingFrame, "AbsoluteWindowSize", true)
Element._forward(ScrollingFrame, "BottomImage")
Element._forward(ScrollingFrame, "CanvasPosition")
Element._forward(ScrollingFrame, "CanvasSize")
Element._forward(ScrollingFrame, "MidImage")
Element._forward(ScrollingFrame, "ScrollBarThickness")
Element._forward(ScrollingFrame, "ScrollingEnabled")
Element._forward(ScrollingFrame, "TopImage")

return ScrollingFrame