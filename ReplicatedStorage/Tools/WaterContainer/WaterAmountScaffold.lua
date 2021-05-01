local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local UDim4 = Load "UI.UDim4"
local Colors = Load "UI.Colors"

return {
	Type = "Frame";
	Name = "WaterAmount";
	BackgroundColor3 = Colors.DarkGray;
	BorderColor3 = Colors.LightGray;
	BorderSizePixel = 1;
	Size = UDim4.new(0.2, 0, 0.075, 0);
	Position = UDim4.new(0.4, 0, 0.925, -80);
	
	{
		Type = "TextView";
		Name = "AmountText";
		BackgroundTransparency = 1;
		Position = UDim4.new(0.05, 0, 0, 0);
		Size = UDim4.new(0.9, 0, 0.4, 0);
		TextColor3 = Colors.White;
		MaximumFontSize = Enum.FontSize.Size18;
		MinimumFontSize = Enum.FontSize.Size10;
		TextXAlignment = Enum.TextXAlignment.Left;
	};
	
	{
		Type = "Bar";
		Name = "AmountBar";
		BackgroundColor3 = Colors.Gray;
		BarColor3 = Colors.Blue;
		Position = UDim4.new(0.1, 0, 0.45, 0);
		Size = UDim4.new(0.8, 0, 0.1, 0);
	};
	
	{
		Scaffold = "TextButton";
		Name = "DrinkButton";
		BackgroundColor3 = Colors.Blue;
		Position = UDim4.new(0.2, 0, 0.6, 0);
		Size = UDim4.new(0.6, 0, 0.3, 0);
		Text = "Drink";
	};
}