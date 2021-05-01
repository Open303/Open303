local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local UDim4 = Load "UI.UDim4"
local Colors = Load "UI.Colors"

return {
	Type = "Frame";
	Name = "AmmoCount";
	BackgroundColor3 = Colors.DarkGray;
	BorderColor3 = Colors.LightGray;
	BorderSizePixel = 1;
	Position = UDim4.new(0.4, 0, 0.96, -80);
	Size = UDim4.new(0.2, 0, 0.04, 0);
	
	{
		Type = "TextView";
		Name = "AmmoText";
		BackgroundTransparency = 1;
		Position = UDim4.new(0.05, 0, 0.1, 0);
		Size = UDim4.new(0.9, 0, 0.8, 0);
		TextColor3 = Colors.White;
		MaximumFontSize = Enum.FontSize.Size18;
		MinimumFontSize = Enum.FontSize.Size10;
		TextXAlignment = Enum.TextXAlignment.Left;
	};
}