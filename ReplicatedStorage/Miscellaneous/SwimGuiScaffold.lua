local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local UDim4 = Load "UI.UDim4"
local Colors = Load "UI.Colors"

return {
	Type = "Button";
	Name = "SwimButton";
	BackgroundColor3 = Colors.Green;
	BorderSizePixel = 1;
	BorderColor3 = Colors.LightGray;
	Position = UDim4.new(0.85, -5, 0.9625, -5);
	Size = UDim4.new(0.15, 0, 0.0375, 0);
	Visible = false;
	
	{
		Type = "TextView";
		Name = "ButtonText";
		BackgroundTransparency = 1;
		Position = UDim4.new(0.05, 0, 0.1, 0);
		Size = UDim4.new(0.9, 0, 0.7, 0);
		Text = "Swim";
		TextColor3 = Colors.White;
		MaximumFontSize = Enum.FontSize.Size18;
		MinimumFontSize = Enum.FontSize.Size10;
		TextXAlignment = Enum.TextXAlignment.Left;
	};
	
	{
		Type = "Bar";
		Name = "SwimTime";
		BackgroundColor3 = Colors.LightGray;
		BarColor3 = Color3.fromHSV(199 / 360, 0.55, 0.9);
		Position = UDim4.new(0, 0, 0.9, 0);
		Size = UDim4.new(1, 0, 0.1, 0);
		Percent = 1;
	};
}