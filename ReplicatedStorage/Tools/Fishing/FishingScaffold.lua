-- may be used in the future. will not be used with launch 2.0.0.          --halo

local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local UDim4 = Load "UI.UDim4"
local Colors = Load "UI.Colors"

return {
	Type = "Frame";
	Name = "TotalButton";
	BackgroundColor3 = Colors.DarkGray;
	BorderColor3 = Colors.LightGray;
	BorderSizePixel = 1;
	Position = UDim4.new(0.35, 0, 0.8, 0);
	Size = UDim4.new(0.3, 0, 0.1, 0);
	
	{	Type = "TextLabel";
		Name = "Text";
		BackgroundTransparency = 1;
		Position = UDim4.new(0, 0, 0, 0);
		Size = UDim4.new(1, 0, 1, 0);		
		Font = Enum.Font.SourceSansBold;
		TextColor3 = Colors.White;
		FontSize = Enum.FontSize.Size36;
		Text = "Not currently fishing...";
	};	
	
}