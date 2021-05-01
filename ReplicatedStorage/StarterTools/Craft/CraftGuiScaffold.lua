local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local UDim4 = Load "UI.UDim4"
local Colors = Load "UI.Colors"

return {
	Type = "Frame";
	Name = "Craft";
	BackgroundTransparency = 1;
	Position = UDim4.new(0.25, 0, 0.25, 0);
	Size = UDim4.new(0.5, 0, 0.5, 0);
	
	
	{
		Type = "Frame";
		Name = "Top";
		BackgroundColor3 = Colors.DarkGray;
		BorderColor3 = Colors.LightGray;
		BorderSizePixel = 1;
		Position = UDim4.new(0, 0, 0, 0);
		Size = UDim4.new(1, 0, 0.1, 0);
		
		{
			Type = "TextView";
			Name = "Title";
			BackgroundTransparency = 1;
			Position = UDim4.new(0.05, 0, 0.1, 0);
			Size = UDim4.new(0.2, 0, 0.8, 0);
			MaximumFontSize = Enum.FontSize.Size32;
			MinimumFontSize = Enum.FontSize.Size12;
			Text = "Crafting";
			TextColor3 = Colors.White;
			TextXAlignment = Enum.TextXAlignment.Left;
		};
		
		{
			Type = "Frame";
			Name = "Search";
			BackgroundColor3 = Colors.Gray;
			Position = UDim4.new(0.3, 0, 0, 0);
			Size = UDim4.new(0.4, 0, 1, 0);
			
			{
				Type = "TextBox";
				Name = "SearchBox";
				BackgroundTransparency = 1;
				Position = UDim4.new(0, 5, 0, 0);
				Size = UDim4.new(0.7, -10, 1, 0);
				MaximumFontSize = Enum.FontSize.Size18;
				MinimumFontSize = Enum.FontSize.Size12;
				Text = "";
				TextColor3 = Colors.White;
				TextXAlignment = Enum.TextXAlignment.Left;
			};

			{
				Scaffold = "TextButton";
				Name = "SearchButton";
				BackgroundColor3 = Colors.Blue;
				Position = UDim4.new(0.7, 0, 0, 0);
				Size = UDim4.new(0.3, 0, 1, 0);
				Text = "Search";
			}
		};
	};
	
	{
		Type = "Frame";
		Name = "ListContainer";
		BackgroundColor3 = Colors.DarkGray;
		BorderColor3 = Colors.LightGray;
		BorderSizePixel = 1;
		Position = UDim4.new(0, 0, 0.1, 5);
		Size = UDim4.new(0.75, -5, 0.9, -5);
		ZIndex = 1;
		
		{
			Type = "ScrollingFrame";
			Name = "RecipeList";
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			Position = UDim4.new(0, 5, 0, 5);
			Size = UDim4.new(1, -10, 1, -10);
			ZIndex = 1;
		};
		
		{
			Type = "TextView";
			Name = "NoRecipesHint";
			BackgroundTransparency = 1;
			Position = UDim4.new(0.05, 0, 0.1, 0);
			Size = UDim4.new(0.9, 0, 0.8, 0);
			Font = Enum.Font.SourceSansBold;
			MaximumFontSize = Enum.FontSize.Size32;
			MinimumFontSize = Enum.FontSize.Size18;
			Text = "You haven't discovered any recipes yet! Gather items to learn their uses.";
			TextColor3 = Colors.Gray;
		}
	};
	
	{
		Type = "Frame";
		Name = "CraftingInfo";
		BackgroundColor3 = Colors.DarkGray;
		BorderColor3 = Colors.LightGray;
		BorderSizePixel = 1;
		Position = UDim4.new(0.75, 0, 0.1, 5);
		Size = UDim4.new(0.25, 0, 0.9, -5);
		
		{
			Type = "Frame";
			Name = "NoRecipe";
			BackgroundTransparency = 1;
			Size = UDim4.new(1, 0, 1, 0);
			
			{
				Type = "TextView";
				Name = "Title";
				BackgroundTransparency = 1;
				Position = UDim4.new(0.025, 0, 0.3, 0);
				Size = UDim4.new(0.95, 0, 0.15, 0);
				Font = Enum.Font.SourceSansBold;
				MaximumFontSize = Enum.FontSize.Size24;
				MinimumFontSize = Enum.FontSize.Size14;
				Text = "Select a recipe";
				TextColor3 = Colors.Gray;
			};
			
			{
				Type = "TextView";
				Name = "Hint";
				BackgroundTransparency = 1;
				Position = UDim4.new(0.05, 0, 0.5, 0);
				Size = UDim4.new(0.9, 0, 0.15, 0);
				Font = Enum.Font.SourceSansBold;
				MaximumFontSize = Enum.FontSize.Size18;
				MinimumFontSize = Enum.FontSize.Size14;
				Text = "Click a button to start crafting a recipe";
				TextColor3 = Colors.Gray;
			}
		};
		
		{
			Type = "Frame";
			Name = "Recipe";
			BackgroundTransparency = 1;
			Size = UDim4.new(1, 0, 1, 0);
			
			{
				Type = "TextView";
				Name = "DisplayName";
				BackgroundTransparency = 1;
				Position = UDim4.new(0.05, 0, 0, 0);
				Size = UDim4.new(0.9, 0, 0.1, 0);
				MaximumFontSize = Enum.FontSize.Size24;
				MinimumFontSize = Enum.FontSize.Size12;
				Text = "Really long display name";
				TextColor3 = Colors.White;
				TextXAlignment = Enum.TextXAlignment.Left;
			};
			
			{
				Type = "TextView";
				Name = "Tagline";
				BackgroundTransparency = 1;
				Position = UDim4.new(0.05, 0, 0.15, 0);
				Size = UDim4.new(0.9, 0, 0.2, 0);
				Font = Enum.Font.SourceSansItalic;
				MaximumFontSize = Enum.FontSize.Size18;
				MinimumFontSize = Enum.FontSize.Size10;
				Text = "This is a tagline. It's a short description of the item and how it's used.";
				TextColor3 = Colors.White;
				TextWrapped = true;
				TextXAlignment = Enum.TextXAlignment.Left;
				TextYAlignment = Enum.TextYAlignment.Top;
			};
			
			{
				Type = "TextView";
				Name = "Ingredients";
				BackgroundTransparency = 1;
				Position = UDim4.new(0.05, 0, 0.35, 0);
				Size = UDim4.new(0.9, 0, 0.25, 0);
				MaximumFontSize = Enum.FontSize.Size18;
				MinimumFontSize = Enum.FontSize.Size10;
				Text = "90x Long Ingredient Name, 2x Ingredient, 5x Other Ingredient, 200x Extremely Ultra Super Long Ingredient Name";
				TextColor3 = Colors.White;
				TextWrapped = true;
				TextXAlignment = Enum.TextXAlignment.Left;
				TextYAlignment = Enum.TextYAlignment.Top;
			};
			
			{
				Type = "TextView";
				Name = "CraftingStation";
				BackgroundTransparency = 1;
				Position = UDim4.new(0.05, 0, 0.625, 0);
				Size = UDim4.new(0.9, 0, 0.15, 0);
				MaximumFontSize = Enum.FontSize.Size18;
				MinimumFontSize = Enum.FontSize.Size10;
				Text = "Crafted at a Supreme Mega Long Crafting Station Name or better.";
				TextColor3 = Colors.White;
				TextWrapped = true;
				TextXAlignment = Enum.TextXAlignment.Left;
				TextYAlignment = Enum.TextYAlignment.Top;
			};
			
			{
				Type = "Button";
				Name = "CraftButton";
				BackgroundColor3 = Colors.Blue;
				Position = UDim4.new(0.1, 0, 0.8, 0);
				Size = UDim4.new(0.8, 0, 0.1, 0);
				Visible = false;
				
				{
					Type = "TextView";
					Name = "ButtonText";
					BackgroundTransparency = 1;
					Position = UDim4.new(0.05, 0, 0.1, 0);
					Size = UDim4.new(0.9, 0, 0.8, 0);
					MaximumFontSize = Enum.FontSize.Size18;
					MinimumFontSize = Enum.FontSize.Size12;
					Text = "Craft";
					TextColor3 = Colors.White;
				};
				
				{
					Type = "TextView";
					Name = "PlusIndicator";
					BackgroundTransparency = 1;
					Position = UDim4.new(0.8, 0, 0.15, 0);
					Size = UDim4.new(0.15, 0, 0.7, 0);
					MaximumFontSize = Enum.FontSize.Size18;
					MinimumFontSize = Enum.FontSize.Size12;
					TextColor3 = Colors.White;
					TextTransparency = 1;
					TextXAlignment = Enum.TextXAlignment.Right;
				}
			};
			
			{
				Type = "TextView";
				Name = "CraftFailureReason";
				BackgroundTransparency = 1;
				Position = UDim4.new(0.05, 0, 0.8, 0);
				Size = UDim4.new(0.9, 0, 0.15, 0);
				Font = Enum.Font.SourceSansBold;
				MaximumFontSize = Enum.FontSize.Size18;
				MinimumFontSize = Enum.FontSize.Size10;
				Text = "You are missing 24x Extremely Ultra Super Long Ingredient Name.";
				TextColor3 = Colors.White;
				TextWrapped = true;
				TextXAlignment = Enum.TextXAlignment.Left;
				TextYAlignment = Enum.TextYAlignment.Top;
			}
		};
	};
	
	{
		Type = "TextButton";
		Name = "OLDTOOLBUTTON";
		Position = UDim4.FromUDim2(UDim2.new(0.7,0, 0, 0));
		Size = UDim4.FromUDim2(UDim2.new(0.30, 0, 0.10, 0));	
		BackgroundColor3 = Colors.ElementsDarkGrey;
		BackgroundTransparency = 0;		
		Font = Enum.Font.SourceSans;
		FontSize = Enum.FontSize.Size18;
		BorderColor3 = Colors.White;
		TextWrapped = true;
		Text = " ";
		
	}
}