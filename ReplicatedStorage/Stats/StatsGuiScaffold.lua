local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local UDim4 = Load "UI.UDim4"
local Colors = Load "UI.Colors"

return {
	Type = "Frame";
	BackgroundColor3 = Colors.DarkGray;
	BorderColor3 = Colors.LightGray;
	BorderSizePixel = 1;
	Position = UDim4.new(0.84, -5, 0.7, 0);
	Size = UDim4.new(0.16, 0, 0.16, 0);
	
	{
		Scaffold = "StatView";
		StatName = "Vitality";
		StatColor = Colors.Red;
	};
	
	
	{
		Scaffold = "StatView";
		StatName = "Hunger";
		StatColor = Colors.OrangeYellowCustom;
		Position = UDim4.new(0, 0, 0.333, 0);
	};
	
	{
		Scaffold = "StatView";
		StatName = "Thirst";
		StatColor = Colors.Blue;
		Position = UDim4.new(0, 0, 0.667, 0);
	};
	
	{
		Scaffold = "StatViewMin";
		StatName = "Saturation";
		StatColor = Colors.OrangeCustom;
		Position = UDim4.new(0,0,0.333,0);
	}
}