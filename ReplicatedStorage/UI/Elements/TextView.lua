local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local Create = Load "Create"
local TextualElement = Load "UI.Elements.TextualElement"

local TextView = {}
setmetatable(TextView, { __index = TextualElement })
TextView.ClassName = "TextView"
TextView.__index = TextualElement.__index
TextView.__newindex = TextualElement.__newindex

function TextView.new()
	local robloxObject = Create "TextLabel" {
		Name = "TextView";
		BackgroundTransparency = 1;
		Font = Enum.Font.SourceSans;
		FontSize = Enum.FontSize.Size18;
		Text = "TextView";
		TextColor3 = Color3.new(1, 1, 1);
		TextScaled = false;
		TextWrapped = true;
	}
	
	local self = setmetatable(TextualElement.new(robloxObject), TextView)
	return self
end

return TextView