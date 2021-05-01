local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local Colors = Load "UI.Colors"
local UDim4 = Load "UI.UDim4"

return {
	Type = "Frame";
	Name = "Hotkeys";
	BackgroundTransparency = 1;
	Position = UDim4.new(0.35, 0, 0.25, 0);
	Size = UDim4.new(0.3, 0, 0.5, 0);
	Visible = false;
	
	{
		Type = "Frame";
		Name = "Top";
		BackgroundColor3 = Colors.DarkGray;
		BorderColor3 = Colors.LightGray;
		BorderSizePixel = 1;
		Size = UDim4.new(1, 0, 0.05, 0);
		
		{
			Type = "TextView";
			Name = "Title";
			BackgroundTransparency = 1;
			Position = UDim4.new(0.05, 0, 0.1, 0);
			Size = UDim4.new(0.25, 0, 0.8, 0);
			MaximumFontSize = Enum.FontSize.Size32;
			MinimumFontSize = Enum.FontSize.Size12;
			Text = "Hotkeys";
			TextColor3 = Colors.White;
			TextXAlignment = Enum.TextXAlignment.Left;
		};
	};
	
	{
		Type = "Frame";
		Name = "EntryContainer";
		BackgroundColor3 = Colors.DarkGray;
		BorderColor3 = Colors.LightGray;
		BorderSizePixel = 1;
		Position = UDim4.new(0, 0, 0.05, 5);
		Size = UDim4.new(1, 0, 0.95, -5);
		
		{
			Type = "ScrollingFrame";
			Name = "EntryList";
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			Position = UDim4.new(0, 5, 0, 5);
			Size = UDim4.new(1, -10, 1, -10);
			ScrollBarThickness = 7;
		};
	};
}