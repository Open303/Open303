local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local UDim4 = Load "UI.UDim4"
local Colors = Load "UI.Colors"

return {
	Type = "TextView";
	Name = "@CategoryName";
	Position = UDim4.new(0, 10, 0, 0);
	Size = UDim4.new(1, -10, 0, 30);
	MaximumFontSize = Enum.FontSize.Size24;
	MinimumFontSize = Enum.FontSize.Size12;
	TextColor3 = Colors.White;
	Text = "@CategoryName";
	TextXAlignment = Enum.TextXAlignment.Left;
	ZIndex = 2;
}