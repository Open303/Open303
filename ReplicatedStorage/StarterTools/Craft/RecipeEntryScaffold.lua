local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local UDim4 = Load "UI.UDim4"
local Colors = Load "UI.Colors"

return {
	Type = "Button";
	Name = "@ResultName";
	Size = UDim4.new(0.5, -5, 0, 30);
	ZIndex = 2;
	
	{
		Type = "TextView";
		Name = "ButtonText";
		Position = UDim4.new(0.05, 0, 0.1, 0);
		Size = UDim4.new(0.9, 0, 0.8, 0);
		Text = "@DisplayName";
		MaximumFontSize = Enum.FontSize.Size18;
		MinimumFontSize = Enum.FontSize.Size12;
		TextColor3 = Colors.White;
		ZIndex = 2;
	}
}