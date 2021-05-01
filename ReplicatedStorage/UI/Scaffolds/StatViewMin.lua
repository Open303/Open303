local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local UDim4 = Load "UI.UDim4"
local Colors = Load "UI.Colors"

return {
	Type = "Frame";
	Name = "@StatName";
	BackgroundTransparency = 1;
	Size = UDim4.new(1, 0, 0.333, 0);
	
	{
		Type = "Bar";
		Name = "StatBar";
		BackgroundTransparency = 1;
		BackgroundColor3 = Colors.Gray;
		BarColor3 = "@StatColor";
		Position = UDim4.new(0.1, 0, 0.6, 0);
		Size = UDim4.new(0.8, 0, .3, 0);
	};

	
	{
		Type = "TextView";
		Name = "StatText";
		BackgroundTransparency = 1;
		Position = UDim4.new(0.05, 0, 0, 0);
		Size = UDim4.new(0.9, 0, 0.5, 0);
		MaximumFontSize = Enum.FontSize.Size18;
		MinimumFontSize = Enum.FontSize.Size10;
		Text = "@StatName";
		TextColor3 = Colors.White;
		TextStrokeTransparency = 1;
		TextTransparency = 1;
		TextXAlignment = Enum.TextXAlignment.Left;
	};
}