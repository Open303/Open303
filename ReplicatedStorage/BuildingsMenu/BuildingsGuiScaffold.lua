local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local UDim4 = Load "UI.UDim4"
local Colors = Load "UI.Colors"

return {
	Type = "Frame";
	Name = "BuildingsBase";
	BackgroundTransparency = 1;
	Position = UDim4.FromUDim2(UDim2.new(0.25, 0, 0.25, 0));
	Size = UDim4.FromUDim2(UDim2.new(0.5, 0, 0.5, 10));
	Visible = false;
	
	{
		Type = "Frame";
		Name = "Top";
		BackgroundColor3 = Colors.DarkGray;
		BorderColor3 = Colors.LightGray;
		BorderSizePixel = 1;
		Size = UDim4.FromUDim2(UDim2.new(1, 0, 0.15, 0));
		
		{
			Type = "TextView";
			Name = "Title";
			Position = UDim4.FromUDim2(UDim2.new(0.05, 0, 0.05, 0));
			Size = UDim4.FromUDim2(UDim2.new(0.15, 0, 0.4, 0));
			
			MaximumFontSize = Enum.FontSize.Size36;
			MinimumFontSize = Enum.FontSize.Size12;
			
			Text = "Buildings";
			TextColor3 = Colors.White;
			TextXAlignment = Enum.TextXAlignment.Left;
		};
		
		{
			Type = "Frame";
			Name = "Search";
			BackgroundColor3 = Colors.Gray;
			Position = UDim4.FromUDim2(UDim2.new(0.25, 0, 0, 0));
			Size = UDim4.FromUDim2(UDim2.new(0.35, 0, 0.5, -4));
			
			{
				Type = "TextBox";
				Name = "SearchBox";
				BackgroundTransparency = 1;
				Position = UDim4.FromUDim2(UDim2.new(0, 5, 0.1, 0));
				Size = UDim4.FromUDim2(UDim2.new(0.7, -10, 0.8, 0));
				
				MaximumFontSize = Enum.FontSize.Size18;
				MinimumFontSize = Enum.FontSize.Size12;
				
				Text = "";
				TextColor3 = Colors.White;
				TextXAlignment = Enum.TextXAlignment.Left;
			};
			
			{
				Type = "Button";
				Name = "SearchButton";
				BackgroundColor3 = Colors.Blue;
				Position = UDim4.FromUDim2(UDim2.new(0.7, 0, 0, 0));
				Size = UDim4.FromUDim2(UDim2.new(0.3, 0, 1, 0));
				
				{
					Type = "TextView";
					Name = "ButtonText";
					Position = UDim4.FromUDim2(UDim2.new(0.05, 0, 0.1, 0));
					Size = UDim4.FromUDim2(UDim2.new(0.9, 0, 0.8, 0));
					
					MaximumFontSize = Enum.FontSize.Size18;
					MinimumFontSize = Enum.FontSize.Size12;
					
					Text = "Search";
					TextColor3 = Colors.White;
				};
			};
		};
		
		{
			Scaffold = "TextButton";
			Name = "RetoolButton";
			BackgroundColor3 = Colors.Blue;
			Text = "Retool";
			Position = UDim4.new(0.025, 0, 0.5, 0);
			Size = UDim4.new(0.2, 0, 0.5, 0);
		};
		
		{
			Scaffold = "TextButton";
			Name = "DeleteButton";
			BackgroundColor3 = Colors.Red;
			Text = "Delete";
			Position = UDim4.new(0.25, 0, 0.5, 0);
			Size = UDim4.new(0.2, 0, 0.5, 0);
		};
		
		{
			Type = "Dropdown";
			Name = "PlayerSelection";
			BackgroundColor3 = Colors.Blue;
			OptionColor3 = Color3.fromHSV(209 / 360, 0.5, 0.85);
			NoOptionText = "(select player)";
			MaxOptionsShown = 6;
			Position = UDim4.new(0.5, 0, 0.5, 0);
			Size = UDim4.new(0.25, 0, 0.5, 0);
			ZIndex = 2;
		};
		
		{
			Scaffold = "TextButton";
			Name = "TransferButton";
			BackgroundColor3 = Colors.Blue;
			Text = "Transfer";
			Position = UDim4.new(0.8, 0, 0.5, 0);
			Size = UDim4.new(0.2, 0, 0.5, 0);
		};
	};
	
	{
		Type = "Frame";
		Name = "BuildingsListBackground";
		BackgroundColor3 = Colors.DarkGray;
		BorderColor3 = Colors.LightGray;
		BorderSizePixel = 1;
		Position = UDim4.FromUDim2(UDim2.new(0, 0, 0.15, 5));
		Size = UDim4.FromUDim2(UDim2.new(1, 0, 0.85, -5));
		ClipsDescendants = true;
		
		{
			Type = "ScrollingFrame";
			Name = "BuildingsList";
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			Position = UDim4.FromUDim2(UDim2.new(0, 5, 0, 5));
			Size = UDim4.FromUDim2(UDim2.new(1, -10, 1, -10));
			ScrollBarThickness = 8;
		}
	}
}