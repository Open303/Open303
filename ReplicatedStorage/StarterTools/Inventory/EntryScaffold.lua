local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local UDim4 = Load "UI.UDim4"

return {
	Type = "Button";
	Name = "@ItemName";
	BackgroundColor3 = Color3.fromRGB(72, 145, 212);
	Position = UDim4.FromUDim2(UDim2.new(0, 0, 0, 0));
	Size = UDim4.FromUDim2(UDim2.new(0.25, -5, 0, 30));
	
	{
		Type = "TextView";
		Name = "ButtonText";
		Position = UDim4.FromUDim2(UDim2.new(0.05, 0, 0.1, 0));
		Size = UDim4.FromUDim2(UDim2.new(0.9, 0, 0.8, 0));
		
		MaximumFontSize = Enum.FontSize.Size18;
		MinimumFontSize = Enum.FontSize.Size12;
		
		Text = "@ItemName";
	};
};