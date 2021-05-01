local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local UDim4 = Load "UI.UDim4"
local Colors = Load "UI.Colors"

return {
	Type = "Frame";
	Name = "GeneralFrame";
	Position = UDim4.FromUDim2(UDim2.new(.275, 0, .15, 0));
	Size = UDim4.FromUDim2(UDim2.new(.45, 0, .6, 0));
	Visible = false;
	BackgroundColor3 = Colors.ElementsDarkishGrey;
	BorderColor3 = Colors.ElementsWhite;
	BorderSizePixel = 0;
	BackgroundTransparency = 1;
		
		{
			Type = "Frame";
			Name = "background";
			Position = UDim4.FromUDim2(UDim2.new(00, 0, 0, 0));
			Size = UDim4.FromUDim2(UDim2.new(1, 0, 1.2, 0));
			Visible = true;
			BackgroundColor3 = Colors.ElementsDarkishGrey;
			BorderColor3 = Colors.ElementsWhite;
			BorderSizePixel = 1;
			BackgroundTransparency = 0;
		};		
		
		{
			Type = "TextLabel";
			Name = "Server Configuration Settings";
			Position = UDim4.FromUDim2(UDim2.new(0,0,0,0));
			Size = UDim4.FromUDim2(UDim2.new(1, 0, 0.1, 0));	
			BackgroundColor3 = Colors.ElementsDarkGrey;
			BackgroundTransparency = 0;
			BorderSizePixel = 1;
			BorderColor3 = Colors.ElementsWhite;		
			Font = Enum.Font.SourceSansBold;
			TextScaled = true;
			TextColor3 = Colors.ElementsWhite;
			TextWrapped = true;
			Text = "Server Configuration Settings";
		};
		{
			Type = "Frame";
			Name = "overallback";
			Size = UDim4.FromUDim2(UDim2.new(1,0,.6,0));
			Position = UDim4.FromUDim2(UDim2.new(0,0,.2,0));
			BackgroundColor3 = Colors.ElementsDarkGrey;
			BackgroundTransparency = 1;
			BorderSizePixel = 1;
			BorderColor3 = Colors.ElementsWhite;		
			
		};
		
		{
			Type = "Frame";
			Name = "Setting1back";
			Size = UDim4.FromUDim2(UDim2.new(.9,0,.1,0));
			Position = UDim4.FromUDim2(UDim2.new(0.05,0,.28,0));
			BackgroundColor3 = Colors.ElementsDarkGrey;
			BackgroundTransparency = 0;
			BorderSizePixel = 0;
			BorderColor3 = Colors.ElementsWhite;		
			
			{
			
				Type = "TextButton";
				Name = "Button1";
				Position = UDim4.FromUDim2(UDim2.new(0.03,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.ElementsGrey;
				BackgroundTransparency = 0;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "Slow";
			
			};
			{
			
				Type = "TextButton";
				Name = "Button2";
				Position = UDim4.FromUDim2(UDim2.new(0.22,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.TribesSandYellow;
				BackgroundTransparency = 0;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "Normal";
			
			};
			{
			
				Type = "TextButton";
				Name = "Button3";
				Position = UDim4.FromUDim2(UDim2.new(0.41,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.ElementsGrey;
				BackgroundTransparency = 0;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "Quick";
			
			};
			{
			
				Type = "TextButton";
				Name = "Button4";
				Position = UDim4.FromUDim2(UDim2.new(0.60,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.ElementsGrey;
				BackgroundTransparency = 0;
				BorderSizePixel = 1;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "Rapid";
			
			};
			{
			
				Type = "TextButton";
				Name = "Save";
				Position = UDim4.FromUDim2(UDim2.new(0.81,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.ElementsGrey;
				BackgroundTransparency = 0;
				BorderSizePixel = 1;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "Apply";
			
			};
		};
		{
			Type = "Frame";
			Name = "Setting2back";
			Size = UDim4.FromUDim2(UDim2.new(.9,0,.1,0));
			Position = UDim4.FromUDim2(UDim2.new(0.05,0,.48,0));
			BackgroundColor3 = Colors.ElementsDarkGrey;
			BackgroundTransparency = 0;
			BorderSizePixel = 0;
			BorderColor3 = Colors.ElementsWhite;	
				
			{
			
				Type = "TextButton";
				Name = "Button1";
				Position = UDim4.FromUDim2(UDim2.new(0.03,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.ElementsGrey;
				BackgroundTransparency = 0;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "Slow";
			
			};
			{
			
				Type = "TextButton";
				Name = "Button2";
				Position = UDim4.FromUDim2(UDim2.new(0.22,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.TribesSandYellow;
				BackgroundTransparency = 0;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "Normal";
			
			};
			{
			
				Type = "TextButton";
				Name = "Button3";
				Position = UDim4.FromUDim2(UDim2.new(0.41,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.ElementsGrey;
				BackgroundTransparency = 0;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "Quick";
			
			};
			{
			
				Type = "TextButton";
				Name = "Button4";
				Position = UDim4.FromUDim2(UDim2.new(0.60,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.ElementsGrey;
				BackgroundTransparency = 0;
				BorderSizePixel = 1;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "Rapid";
			
			};
			{
			
				Type = "TextButton";
				Name = "Save";
				Position = UDim4.FromUDim2(UDim2.new(0.81,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.ElementsGrey;
				BackgroundTransparency = 0;
				BorderSizePixel = 1;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "Apply";
			
			};
		};
		{
			Type = "Frame";
			Name = "Setting3back";
			Size = UDim4.FromUDim2(UDim2.new(.9,0,.1,0));
			Position = UDim4.FromUDim2(UDim2.new(0.05,0,.88,0));
			BackgroundColor3 = Colors.ElementsDarkGrey;
			BackgroundTransparency = 0;
			BorderSizePixel = 0;
			BorderColor3 = Colors.ElementsWhite;		
			
		
			{
			
				Type = "TextButton";
				Name = "Button1";
				Position = UDim4.FromUDim2(UDim2.new(0.03,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.ElementsGrey;
				BackgroundTransparency = 0;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "Frozen";
			
			};
			{
			
				Type = "TextButton";
				Name = "Button2";
				Position = UDim4.FromUDim2(UDim2.new(0.22,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.TribesSandYellow;
				BackgroundTransparency = 0;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "Normal";
			
			};
			{
			
				Type = "TextButton";
				Name = "Button3";
				Position = UDim4.FromUDim2(UDim2.new(0.41,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.ElementsGrey;
				BackgroundTransparency = 0;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "Quick";
			
			};
			{
			
				Type = "TextButton";
				Name = "Button4";
				Position = UDim4.FromUDim2(UDim2.new(0.60,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.ElementsGrey;
				BackgroundTransparency = 0;
				BorderSizePixel = 1;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "Rapid";
			
			};
			{
			
				Type = "TextButton";
				Name = "Save";
				Position = UDim4.FromUDim2(UDim2.new(0.81,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.ElementsGrey;
				BackgroundTransparency = 0;
				BorderSizePixel = 1;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "Apply";
			};
		};
		{
			Type = "Frame";
			Name = "Setting4back";
			Size = UDim4.FromUDim2(UDim2.new(.9,0,.1,0));
			Position = UDim4.FromUDim2(UDim2.new(0.05,0,1.08,0));
			BackgroundColor3 = Colors.ElementsDarkGrey;
			BackgroundTransparency = 0;
			BorderSizePixel = 0;
			BorderColor3 = Colors.ElementsWhite;		
			
		
			{
			
				Type = "TextButton";
				Name = "Button1";
				Position = UDim4.FromUDim2(UDim2.new(0.03,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.ElementsGrey;
				BackgroundTransparency = 0;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "75% HP";
			
			};
			{
			
				Type = "TextButton";
				Name = "Button2";
				Position = UDim4.FromUDim2(UDim2.new(0.22,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.TribesSandYellow;
				BackgroundTransparency = 0;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "100% HP";
			
			};
			{
			
				Type = "TextButton";
				Name = "Button3";
				Position = UDim4.FromUDim2(UDim2.new(0.41,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.ElementsGrey;
				BackgroundTransparency = 0;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "125% HP";
			
			};
			{
			
				Type = "TextButton";
				Name = "Button4";
				Position = UDim4.FromUDim2(UDim2.new(0.60,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.ElementsGrey;
				BackgroundTransparency = 0;
				BorderSizePixel = 1;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "150% HP";
			
			};
			{
			
				Type = "TextButton";
				Name = "Save";
				Position = UDim4.FromUDim2(UDim2.new(0.81,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.ElementsGrey;
				BackgroundTransparency = 0;
				BorderSizePixel = 1;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "Apply";
			
			};
		
		};
		{
			Type = "Frame";
			Name = "Setting5back";
			Size = UDim4.FromUDim2(UDim2.new(.9,0,.1,0));
			Position = UDim4.FromUDim2(UDim2.new(0.05,0,.68,0));
			BackgroundColor3 = Colors.ElementsDarkGrey;
			BackgroundTransparency = 0;
			BorderSizePixel = 0;
			BorderColor3 = Colors.ElementsWhite;		
			
		
			{
			
				Type = "TextButton";
				Name = "Button1";
				Position = UDim4.FromUDim2(UDim2.new(0.03,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.ElementsGrey;
				BackgroundTransparency = 0;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "Slow";
			
			};
			{
			
				Type = "TextButton";
				Name = "Button2";
				Position = UDim4.FromUDim2(UDim2.new(0.22,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.TribesSandYellow;
				BackgroundTransparency = 0;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "Normal";
			
			};
			{
			
				Type = "TextButton";
				Name = "Button3";
				Position = UDim4.FromUDim2(UDim2.new(0.41,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.ElementsGrey;
				BackgroundTransparency = 0;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "Quick";
			
			};
			{
			
				Type = "TextButton";
				Name = "Button4";
				Position = UDim4.FromUDim2(UDim2.new(0.60,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.ElementsGrey;
				BackgroundTransparency = 0;
				BorderSizePixel = 1;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "Rapid";
			
			};
			{
			
				Type = "TextButton";
				Name = "Save";
				Position = UDim4.FromUDim2(UDim2.new(0.81,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.16, 0, 0.8, 0));	
				BackgroundColor3 = Colors.ElementsGrey;
				BackgroundTransparency = 0;
				BorderSizePixel = 1;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				BorderColor3 = Colors.ElementsBlack;		
				Text = "Apply";
			
			};
		};
		{
			Type = "TextLabel";
			Name = "CONFIGTEXT1";
			Position = UDim4.FromUDim2(UDim2.new(0,0,.2,0));
			Size = UDim4.FromUDim2(UDim2.new(1, 0, 0.08, 0));	
			BackgroundColor3 = Colors.ElementsDarkGrey;
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			BorderColor3 = Colors.ElementsWhite;		
			Font = Enum.Font.SourceSansBold;
			TextScaled = false;
			FontSize = Enum.FontSize.Size24;
			TextColor3 = Colors.ElementsWhite;
			TextWrapped = false;
			Text = "Speed of Hunger, Thirst, and Saturation Decay";
		};	
		{
			Type = "TextLabel";
			Name = "CONFIGTEXT2";
			Position = UDim4.FromUDim2(UDim2.new(0,0,.4,0));
			Size = UDim4.FromUDim2(UDim2.new(1, 0, 0.08, 0));	
			BackgroundColor3 = Colors.ElementsDarkGrey;
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			BorderColor3 = Colors.ElementsWhite;		
			Font = Enum.Font.SourceSansBold;
			TextScaled = false;
			FontSize = Enum.FontSize.Size24;
			TextColor3 = Colors.ElementsWhite;
			TextWrapped = false;
			Text = "Speed of Overall Item and Resource Regeneration";
		};	
		{
			Type = "TextLabel";
			Name = "CONFIGTEXT3";
			Position = UDim4.FromUDim2(UDim2.new(0,0,.8,0));
			Size = UDim4.FromUDim2(UDim2.new(1, 0, 0.08, 0));	
			BackgroundColor3 = Colors.ElementsDarkGrey;
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			BorderColor3 = Colors.ElementsWhite;		
			Font = Enum.Font.SourceSansBold;
			TextScaled = false;
			FontSize = Enum.FontSize.Size24;
			TextColor3 = Colors.ElementsWhite;
			TextWrapped = false;
			Text = "How Fast the Day and Night Cycle Passes";
		};	
		{
			Type = "TextLabel";
			Name = "CONFIGTEXT4";
			Position = UDim4.FromUDim2(UDim2.new(0,0,1,0));
			Size = UDim4.FromUDim2(UDim2.new(1, 0, 0.08, 0));	
			BackgroundColor3 = Colors.ElementsDarkGrey;
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			BorderColor3 = Colors.ElementsWhite;		
			Font = Enum.Font.SourceSansBold;
			TextScaled = false;
			FontSize = Enum.FontSize.Size24;
			TextColor3 = Colors.ElementsWhite;
			TextWrapped = false;
			Text = "Amount of Maximum Health Each Player Has";
		};	
		{
			Type = "TextLabel";
			Name = "CONFIGTEXT5";
			Position = UDim4.FromUDim2(UDim2.new(0,0,.6,0));
			Size = UDim4.FromUDim2(UDim2.new(1, 0, 0.08, 0));	
			BackgroundColor3 = Colors.ElementsDarkGrey;
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			BorderColor3 = Colors.ElementsWhite;		
			Font = Enum.Font.SourceSansBold;
			TextScaled = false;
			FontSize = Enum.FontSize.Size24;
			TextColor3 = Colors.ElementsWhite;
			TextWrapped = false;
			Text = "Speed at Which Crops Grow and Chickens Hatch";
		};	

}	
	