local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local UDim4 = Load "UI.UDim4"
local Colors = Load "UI.Colors"

return {
	Type = "Frame";
	Name = "InventoryBase";
	BackgroundTransparency = 1;
	Position = UDim4.FromUDim2(UDim2.new(0.3, 0, 0.25, 0));
	Size = UDim4.FromUDim2(UDim2.new(0.4, 0, 0.5, 10));
	Visible = false;
	
	{
		Type = "Frame";
		Name = "Top";
		BackgroundColor3 = Colors.DarkGray;
		BorderColor3 = Colors.LightGray;
		BorderSizePixel = 1;
		ClipsDescendants = true;
		Size = UDim4.FromUDim2(UDim2.new(1, 0, 0.1, 0));
		
		{
			Type = "Frame";
			Name = "DefaultView";
			BackgroundTransparency = 1;
			Size = UDim4.FromUDim2(UDim2.new(1, 0, 1, 0));
			
			{
				Type = "TextView";
				Name = "Title";
				Position = UDim4.FromUDim2(UDim2.new(0.05, 0, 0.1, 0));
				Size = UDim4.FromUDim2(UDim2.new(0.15, 0, 0.8, 0));
				
				MaximumFontSize = Enum.FontSize.Size36;
				MinimumFontSize = Enum.FontSize.Size12;
				
				Text = "Inventory";
				TextColor3 = Colors.White;
				TextXAlignment = Enum.TextXAlignment.Left;
			};
			
			{
				Type = "Button";
				Name = "RemoveArmor";
				BackgroundColor3 = Colors.Red;
				Position = UDim4.FromUDim2(UDim2.new(0.8, 0, 0, 0));
				Size = UDim4.FromUDim2(UDim2.new(0.2, 0, 1, 0));
				Modal = true;
				
				{
					Type = "TextView";
					Name = "ButtonText";
					Position = UDim4.FromUDim2(UDim2.new(0.05, 0, 0.1, 0));
					Size = UDim4.FromUDim2(UDim2.new(0.9, 0, 0.8, 0));
					
					MaximumFontSize = Enum.FontSize.Size18;
					MinimumFontSize = Enum.FontSize.Size12;
					
					Text = "Remove Armor";
					TextColor3 = Colors.White;
				};
			};
			
			{
				Type = "Frame";
				Name = "Search";
				BackgroundColor3 = Colors.Gray;
				Position = UDim4.FromUDim2(UDim2.new(0.25, 0, 0, 0));
				Size = UDim4.FromUDim2(UDim2.new(0.35, 0, 1, 0));
				
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
		};
		
		{
			Type = "Frame";
			Name = "PlacingView";
			BackgroundTransparency = 1;
			Size = UDim4.FromUDim2(UDim2.new(1, 0, 1, 0));
			Position = UDim4.FromUDim2(UDim2.new(0, 0, 1, 0));
			
			{
				Type = "Button";
				Name = "CancelPlacement";
				BackgroundColor3 = Colors.Red;
				Position = UDim4.FromUDim2(UDim2.new(0.75, 0, 0, 0));
				Size = UDim4.FromUDim2(UDim2.new(0.25, 0, 1, 0));
				
				{
					Type = "TextView";
					Name = "ButtonText";
					Position = UDim4.FromUDim2(UDim2.new(0.05, 0, 0.1, 0));
					Size = UDim4.FromUDim2(UDim2.new(0.9, 0, 0.8, 0));
					
					MaximumFontSize = Enum.FontSize.Size18;
					MinimumFontSize = Enum.FontSize.Size12;
					
					Text = "Cancel";
					TextColor3 = Colors.White;
				};
			};
			
			{
				Type = "TextView";
				Name = "PlacementHint";
				Position = UDim4.FromUDim2(UDim2.new(0.05, 0, 0.1, 0));
				Size = UDim4.FromUDim2(UDim2.new(0.7, 0, 0.8, 0));
				
				MaximumFontSize = Enum.FontSize.Size18;
				MinimumFontSize = Enum.FontSize.Size12;
				
				Text = "Placement hint";
				TextColor3 = Colors.White;
				TextXAlignment = Enum.TextXAlignment.Left;
			}
		};
	};
	
	{
		Type = "Frame";
		Name = "ItemListBackground";
		BackgroundColor3 = Colors.DarkGray;
		BorderColor3 = Colors.LightGray;
		BorderSizePixel = 1;
		Position = UDim4.FromUDim2(UDim2.new(0, 0, 0.1, 5));
		Size = UDim4.FromUDim2(UDim2.new(1, 0, 0.9, -5));
		ClipsDescendants = true;
		
		{
			Type = "ScrollingFrame";
			Name = "ItemList";
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			Position = UDim4.FromUDim2(UDim2.new(0, 5, 0, 5));
			Size = UDim4.FromUDim2(UDim2.new(1, -10, 1, -10));
			ScrollBarThickness = 8;
		}
	}
}