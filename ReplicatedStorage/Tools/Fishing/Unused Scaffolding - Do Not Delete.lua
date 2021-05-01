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
	Position = UDim4.new(0.425, 45, 0.7, 0);
	Size = UDim4.new(0, 150, 0, 150);
	
	{	Type = "TextBox";
		Name = "PressIndicator";
		BackgroundTransparency = 1;
		BorderSizePixel = 1;
		Position = UDim4.new(0, 5, 0, 5);
		Size = UDim4.new(0, 140, 0, 30);		
		Font = Enum.Font.SourceSansBold;
		FontSize = Enum.FontSize.Size24;
		Text = "NOT FISHING";
	};	
	
	{
		Type = "Frame";
		Name = "LetterBackground";	
		BackgroundColor3 = Colors.Black;
		BorderColor3 = Colors.LightGray;
		BorderSizePixel = 1;
		Position = UDim4.new(0, 35, 0, 55);
		Size = UDim4.new(0, 80, 0, 80);
	};

	
	{	Type = "TextBox";
		Name = "CHANGER";
		BackgroundTransparency = 1;
		Position = UDim4.new(0,5,0,35);
		Size = UDim4.new(0,140,0,110);
		Font = Enum.Font.SourceSansBold;
		FontSize = Enum.FontSize.Size96;
		Text = " ";		
	};
}