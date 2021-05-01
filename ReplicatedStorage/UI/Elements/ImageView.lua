local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local Create = Load "Create"
local Element = Load "UI.Elements.Element"

local ImageView = {}
setmetatable(ImageView, { __index = Element })
ImageView.ClassName = "ImageView"
ImageView.__index = Element.__index
ImageView.__newindex = Element.__newindex

function ImageView.new()
	local robloxObject = Create "ImageView" {
		Name = "ImageView";
		BackgroundColor3 = Color3.new(1, 1, 1);
		BorderSizePixel = 0;
	}
	
	local self = setmetatable(Element.new(robloxObject), ImageView)
	return self
end

Element._forward(ImageView, "Image")
Element._forward(ImageView, "ImageColor3")
Element._forward(ImageView, "ImageRectOffset")
Element._forward(ImageView, "ImageRectSize")
Element._forward(ImageView, "ImageTransparency")
Element._forward(ImageView, "ScaleType")
Element._forward(ImageView, "SliceCenter")

return ImageView