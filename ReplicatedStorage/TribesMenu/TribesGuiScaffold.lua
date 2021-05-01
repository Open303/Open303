local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local UDim4 = Load "UI.UDim4"
local Colors = Load "UI.Colors"

return {
	Type = "Frame";
	Name = "WHOLESCREENENTITTY";
	BackgroundTransparency = 1;
	Position = UDim4.FromUDim2(UDim2.new(0, 0, 0, 0));
	Size = UDim4.FromUDim2(UDim2.new(1, 0, 1, 0));
	Visible = true;
		
		{
			Type = "Frame";
			Name = "DisplayZone";
			BackgroundTransparency = 1;
			Position = UDim4.FromUDim2(UDim2.new(0.335, 0, 0.2, 0));
			Size = UDim4.FromUDim2(UDim2.new(0.6, 0, 0.6, 10));
			Visible = false;
		
			{
				Type = "Frame";
				Name = "TransparentBackground";
				Position = UDim4.FromUDim2(UDim2.new(0, 0, 0.001, 0));
				Size = UDim4.FromUDim2(UDim2.new(0.55, 0, 0.999, 0));
				BackgroundColor3 = Colors.ElementsDarkGrey;
				BorderColor3 = Colors.ElementsWhite;
				BorderSizePixel = 1;
				BackgroundTransparency = 0.5;
			};	
			
			{
				Type = "Frame";
				Name = "TribeColorDisplay";
				Position = UDim4.FromUDim2(UDim2.new(0.25, 0, 0.3, 3));
				Size = UDim4.FromUDim2(UDim2.new(0.3, 0, 0.1, 0));
				BackgroundColor3 = Colors.ElementsWhite;
				BorderColor3 = Colors.ElementsWhite;
				BorderSizePixel = 1;
				BackgroundTransparency = 0;
				
				{
					Type = "Frame";
					Name = "currentcolor";
					Position = UDim4.FromUDim2(UDim2.new(0.05, 0, 0.2, 0));
					Size = UDim4.FromUDim2(UDim2.new(0.9, 0, 0.6, 0));
					BackgroundColor3 = Colors.ElementsWhite;
					BorderColor3 = Colors.ElementsBlack;
					BorderSizePixel = 4;
					BackgroundTransparency = 0;
				};
			};	
			
			{
				Type = "Frame";
				Name = "VanishBackground";
				Position = UDim4.FromUDim2(UDim2.new(0, 0, 0.3, 3));
				Size = UDim4.FromUDim2(UDim2.new(0.2, 0, 0.6, 0));
				BackgroundColor3 = Colors.ElementsWhite;
				BorderColor3 = Colors.ElementsWhite;
				BorderSizePixel = 1;
			};
			
			{
				Type = "TextButton";
				Name = "CREATE";
				Position = UDim4.FromUDim2(UDim2.new(0, 0, 0.9, 0));
				Size = UDim4.FromUDim2(UDim2.new(0.2, 0, 0.1, 0));	
				BackgroundColor3 = Colors.ElementsCyan;
				BackgroundTransparency = 0;
				BorderColor3 = Colors.ElementsWhite;		
				Font = Enum.Font.SourceSansBold;
				FontSize = Enum.FontSize.Size28;
				TextColor3 = Colors.ElementsBlack;
				TextWrapped = true;
				Text = "CREATE";
			};
			
			{
				Type = "TextButton";
				Name = "INVITEMEMBER";
				Position = UDim4.FromUDim2(UDim2.new(0.25,0,0.46666,0));
				Size = UDim4.FromUDim2(UDim2.new(0.3, 0, 0.1, 0));	
				BackgroundColor3 = Colors.ElementsCyan;
				BackgroundTransparency = 0;
				BorderColor3 = Colors.ElementsWhite;		
				Font = Enum.Font.SourceSansBold;
				FontSize = Enum.FontSize.Size28;
				TextColor3 = Colors.ElementsBlack;
				TextWrapped = true;
				Text = "INVITE MEMBER";
			};
	
			{
				Type = "TextButton";
				Name = "LEAVETRIBE";
				Position = UDim4.FromUDim2(UDim2.new(0.25,0,0.9,0));
				Size = UDim4.FromUDim2(UDim2.new(0.3, 0, 0.1, 0));	
				BackgroundColor3 = Colors.ElementsCyan;
				BackgroundTransparency = 0;
				BorderColor3 = Colors.ElementsWhite;		
				Font = Enum.Font.SourceSansBold;
				FontSize = Enum.FontSize.Size28;
				TextColor3 = Colors.ElementsBlack;
				TextWrapped = true;
				Text = "LEAVE CURRENT TRIBE";
			};
			
			{
				Type = "TextButton";
				Name = "YESNO";
				Position = UDim4.FromUDim2(UDim2.new(0.45, 0, 0.73333, 0));
				Size = UDim4.FromUDim2(UDim2.new(0.1, 0, 0.1, 0));	
				BackgroundColor3 = Colors.ElementsCyan;
				BackgroundTransparency = 0;
				BorderColor3 = Colors.ElementsWhite;		
				Font = Enum.Font.SourceSansBold;
				FontSize = Enum.FontSize.Size28;
				TextColor3 = Colors.ElementsBlack;
				TextWrapped = true;
				Text = "YES";
			};
			
			{
				Type = "TextBox";
				Name = "memberinput";
				Position = UDim4.FromUDim2(UDim2.new(0.25,0,0.5666666,1));
				Size = UDim4.FromUDim2(UDim2.new(0.3, 0, 0.1, 0));	
				BackgroundColor3 = Colors.ElementsGrey;
				BackgroundTransparency = 0;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsWhite;		
				Font = Enum.Font.SourceSans;
				FontSize = Enum.FontSize.Size18;
				TextColor3 = Colors.ElementsBlack;
				TextWrapped = true;
				Text = "Type player's name here...";
			};
			
			{
				Type = "TextBox";
				Name = "nameinput";
				Position = UDim4.FromUDim2(UDim2.new(0,0,0.15,2));
				Size = UDim4.FromUDim2(UDim2.new(0.2, 0, 0.075, 0));	
				BackgroundColor3 = Colors.ElementsGrey;
				BackgroundTransparency = 0;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsWhite;		
				Font = Enum.Font.SourceSans;
				FontSize = Enum.FontSize.Size18;
				TextColor3 = Colors.ElementsBlack;
				TextWrapped = true;
				Text = "Type name here...";
			};
			
			{
				Type = "TextLabel";
				Name = "Create a New Tribe";
				Position = UDim4.FromUDim2(UDim2.new(0,0,0.001,0));
				Size = UDim4.FromUDim2(UDim2.new(0.20, 0, 0.152, 0));	
				BackgroundColor3 = Colors.ElementsDarkGrey;
				BackgroundTransparency = 0;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsWhite;		
				Font = Enum.Font.SourceSansBold;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsWhite;
				TextWrapped = true;
				Text = "Create a New Tribe";
			};
			
			{
				Type = "TextLabel";
				Name = "Receive Invites?";
				Position = UDim4.FromUDim2(UDim2.new(0.25,0,0.73333,0));
				Size = UDim4.FromUDim2(UDim2.new(0.2, 0, 0.1, 0));	
				BackgroundColor3 = Colors.ElementsDarkGrey;
				BackgroundTransparency = 0;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsWhite;		
				Font = Enum.Font.SourceSansBold;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsWhite;
				TextWrapped = true;
				Text = "Receive Invites?";
			};	
			
			{
				Type = "TextLabel";
				Name = "Current Tribe";
				Position = UDim4.FromUDim2(UDim2.new(0.25,0,0.001,0));
				Size = UDim4.FromUDim2(UDim2.new(0.3, 0, 0.1, 0));	
				BackgroundColor3 = Colors.ElementsDarkGrey;
				BackgroundTransparency = 0;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsWhite;		
				Font = Enum.Font.SourceSansBold;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsWhite;
				TextWrapped = true;
				Text = "Current Tribe";
			};	
			
			{
				Type = "TextLabel";
				Name = "Current Tribe Color";
				Position = UDim4.FromUDim2(UDim2.new(0.25,0,0.2,1));
				Size = UDim4.FromUDim2(UDim2.new(0.3, 0, 0.1, 0));	
				BackgroundColor3 = Colors.ElementsDarkGrey;
				BackgroundTransparency = 0;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsWhite;		
				Font = Enum.Font.SourceSansBold;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsWhite;
				TextWrapped = true;
				Text = "Current Tribe Color";
			};
					
			{
				Type = "TextLabel";
				Name = "activetribe";
				Position = UDim4.FromUDim2(UDim2.new(0.25,0,0.1,0));
				Size = UDim4.FromUDim2(UDim2.new(0.3, 0, 0.1, 0));	
				BackgroundColor3 = Colors.ElementsGrey;
				BackgroundTransparency = 0;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsWhite;		
				Font = Enum.Font.SourceSans;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
				TextWrapped = true;
				Text = "NOT IN ANY TRIBE";
			};		
			
			{
				Type = "TextLabel";
				Name = "colordisplay";
				Position = UDim4.FromUDim2(UDim2.new(0,0,0.225,3));
				Size = UDim4.FromUDim2(UDim2.new(0.2, 0, 0.075, 0));	
				BackgroundColor3 = Colors.ElementsWhite;
				BackgroundTransparency = 0;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsWhite;		
				Font = Enum.Font.SourceSansBold;
				FontSize = Enum.FontSize.Size18;
				TextColor3 = Colors.ElementsBlack;
				TextWrapped = true;
				Text = "SELECTED COLOR";
			};
				
			{
				Type = "TextLabel";
				Name = "feedbackbar";
				Position = UDim4.FromUDim2(UDim2.new(0,0,1.05,0));
				Size = UDim4.FromUDim2(UDim2.new(0.55,0,0.07,0));	
				BackgroundColor3 = Colors.ElementsDarkGrey;
				BackgroundTransparency = 0.5;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsWhite;		
				Font = Enum.Font.SourceSansBold;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsWhite;
				TextWrapped = true;
				Text = "";
			};	
			
			{
				Type = "Frame";
				Name = "ColorPalletZone";
				Position = UDim4.FromUDim2(UDim2.new(0.01, 0, 0.3, 10));
				Size = UDim4.FromUDim2(UDim2.new(0.18, 0, 0.55, 0));
				BackgroundTransparency = 1;
				
				{
					Type = "TextButton";
					Name = "L1";
					Position = UDim4.FromUDim2(UDim2.new(0.03,0,0.01,0));
					Size = UDim4.FromUDim2(UDim2.new(0.45, 0, 0.08, 0));	
					BackgroundColor3 = Colors.TribesMediumRed;
					BackgroundTransparency = 0;
					BorderSizePixel = 1;
					BorderColor3 = Colors.ElementsBlack;		
					Text = " ";
				};
				
				{
					Type = "TextButton";
					Name = "L2";
					Position = UDim4.FromUDim2(UDim2.new(0.03,0,0.11,0));
					Size = UDim4.FromUDim2(UDim2.new(0.45, 0, 0.08, 0));	
					BackgroundColor3 = Colors.TribesMediumBlue;
					BackgroundTransparency = 0;
					BorderSizePixel = 1;
					BorderColor3 = Colors.ElementsBlack;		
					Text = " ";
				};
				
				{
					Type = "TextButton";
					Name = "L3";
					Position = UDim4.FromUDim2(UDim2.new(0.03,0,0.21,0));
					Size = UDim4.FromUDim2(UDim2.new(0.45, 0, 0.08, 0));	
					BackgroundColor3 = Colors.TribesLightGreen;
					BackgroundTransparency = 0;
					BorderSizePixel = 1;
					BorderColor3 = Colors.ElementsBlack;		
					Text = " ";
				};
				
				{
					Type = "TextButton";
					Name = "L4";
					Position = UDim4.FromUDim2(UDim2.new(0.03,0,0.31,0));
					Size = UDim4.FromUDim2(UDim2.new(0.45, 0, 0.08, 0));	
					BackgroundColor3 = Colors.TribesSandYellow;
					BackgroundTransparency = 0;
					BorderSizePixel = 1;
					BorderColor3 = Colors.ElementsBlack;		
					Text = " ";
				};
				
				{
					Type = "TextButton";
					Name = "L5";
					Position = UDim4.FromUDim2(UDim2.new(0.03,0,0.41,0));
					Size = UDim4.FromUDim2(UDim2.new(0.45, 0, 0.08, 0));	
					BackgroundColor3 = Colors.TribesLightOrange;
					BackgroundTransparency = 0;
					BorderSizePixel = 1;
					BorderColor3 = Colors.ElementsBlack;		
					Text = " ";
				};
				
				{
					Type = "TextButton";
					Name = "L6";
					Position = UDim4.FromUDim2(UDim2.new(0.03,0,0.51,0));
					Size = UDim4.FromUDim2(UDim2.new(0.45, 0, 0.08, 0));	
					BackgroundColor3 = Colors.TribesLightPurple;
					BackgroundTransparency = 0;
					BorderSizePixel = 1;
					BorderColor3 = Colors.ElementsBlack;		
					Text = " ";
				};
				
				{
					Type = "TextButton";
					Name = "L7";
					Position = UDim4.FromUDim2(UDim2.new(0.03,0,0.61,0));
					Size = UDim4.FromUDim2(UDim2.new(0.45, 0, 0.08, 0));	
					BackgroundColor3 = Colors.TribesLightBlue;
					BackgroundTransparency = 0;
					BorderSizePixel = 1;
					BorderColor3 = Colors.ElementsBlack;		
					Text = " ";
				};
				
				{
					Type = "TextButton";
					Name = "L8";
					Position = UDim4.FromUDim2(UDim2.new(0.03,0,0.71,0));
					Size = UDim4.FromUDim2(UDim2.new(0.45, 0, 0.08, 0));	
					BackgroundColor3 = Colors.TribesLightPinkPurple;
					BackgroundTransparency = 0;
					BorderSizePixel = 1;
					BorderColor3 = Colors.ElementsBlack;		
					Text = " ";
				};
				
				{
					Type = "TextButton";
					Name = "L9";
					Position = UDim4.FromUDim2(UDim2.new(0.03,0,0.81,0));
					Size = UDim4.FromUDim2(UDim2.new(0.45, 0, 0.08, 0));	
					BackgroundColor3 = Colors.TribesMagentaPurple;
					BackgroundTransparency = 0;
					BorderSizePixel = 1;
					BorderColor3 = Colors.ElementsBlack;		
					Text = " ";
				};
				
				{
					Type = "TextButton";
					Name = "L10";
					Position = UDim4.FromUDim2(UDim2.new(0.03,0,0.91,0));
					Size = UDim4.FromUDim2(UDim2.new(0.45, 0, 0.08, 0));	
					BackgroundColor3 = Colors.TribesDarkGrey;
					BackgroundTransparency = 0;
					BorderSizePixel = 1;
					BorderColor3 = Colors.ElementsBlack;		
					Text = " ";
				};
				
				{
					Type = "TextButton";
					Name = "R1";
					Position = UDim4.FromUDim2(UDim2.new(0.52,0,0.01,0));
					Size = UDim4.FromUDim2(UDim2.new(0.45, 0, 0.08, 0));	
					BackgroundColor3 = Colors.TribesDarkRed;
					BackgroundTransparency = 0;
					BorderSizePixel = 1;
					BorderColor3 = Colors.ElementsBlack;		
					Text = " ";
				};
				
				{
					Type = "TextButton";
					Name = "R2";
					Position = UDim4.FromUDim2(UDim2.new(0.52,0,0.11,0));
					Size = UDim4.FromUDim2(UDim2.new(0.45, 0, 0.08, 0));	
					BackgroundColor3 = Colors.TribesDarkBlue;
					BackgroundTransparency = 0;
					BorderSizePixel = 1;
					BorderColor3 = Colors.ElementsBlack;		
					Text = " ";
				};
				
				{
					Type = "TextButton";
					Name = "R3";
					Position = UDim4.FromUDim2(UDim2.new(0.52,0,0.21,0));
					Size = UDim4.FromUDim2(UDim2.new(0.45, 0, 0.08, 0));	
					BackgroundColor3 = Colors.TribesDarkGreen;
					BackgroundTransparency = 0;
					BorderSizePixel = 1;
					BorderColor3 = Colors.ElementsBlack;		
					Text = " ";
				};
				
				{
					Type = "TextButton";
					Name = "R4";
					Position = UDim4.FromUDim2(UDim2.new(0.52,0,0.31,0));
					Size = UDim4.FromUDim2(UDim2.new(0.45, 0, 0.08, 0));	
					BackgroundColor3 = Colors.TribesYellow;
					BackgroundTransparency = 0;
					BorderSizePixel = 1;
					BorderColor3 = Colors.ElementsBlack;		
					Text = " ";
				};
				
				{
					Type = "TextButton";
					Name = "R5";
					Position = UDim4.FromUDim2(UDim2.new(0.52,0,0.41,0));
					Size = UDim4.FromUDim2(UDim2.new(0.45, 0, 0.08, 0));	
					BackgroundColor3 = Colors.TribesBrownOrange;
					BackgroundTransparency = 0;
					BorderSizePixel = 1;
					BorderColor3 = Colors.ElementsBlack;		
					Text = " ";
				};
				
				{
					Type = "TextButton";
					Name = "R6";
					Position = UDim4.FromUDim2(UDim2.new(0.52,0,0.51,0));
					Size = UDim4.FromUDim2(UDim2.new(0.45, 0, 0.08, 0));	
					BackgroundColor3 = Colors.TribesDarkPurple;
					BackgroundTransparency = 0;
					BorderSizePixel = 1;
					BorderColor3 = Colors.ElementsBlack;		
					Text = " ";
				};
				
				{
					Type = "TextButton";
					Name = "R7";
					Position = UDim4.FromUDim2(UDim2.new(0.52,0,0.61,0));
					Size = UDim4.FromUDim2(UDim2.new(0.45, 0, 0.08, 0));	
					BackgroundColor3 = Colors.TribesSandBlue;
					BackgroundTransparency = 0;
					BorderSizePixel = 1;
					BorderColor3 = Colors.ElementsBlack;		
					Text = " ";
				};
				
				{
					Type = "TextButton";
					Name = "R8";
					Position = UDim4.FromUDim2(UDim2.new(0.52,0,0.71,0));
					Size = UDim4.FromUDim2(UDim2.new(0.45, 0, 0.08, 0));	
					BackgroundColor3 = Colors.TribesMediumGrey;
					BackgroundTransparency = 0;
					BorderSizePixel = 1;
					BorderColor3 = Colors.ElementsBlack;		
					Text = " ";
				};
				
				{
					Type = "TextButton";
					Name = "R9";
					Position = UDim4.FromUDim2(UDim2.new(0.52,0,0.81,0));
					Size = UDim4.FromUDim2(UDim2.new(0.45, 0, 0.08, 0));	
					BackgroundColor3 = Colors.TribesLightRed;
					BackgroundTransparency = 0;
					BorderSizePixel = 1;
					BorderColor3 = Colors.ElementsBlack;		
					Text = " ";
				};
				
				{
					Type = "TextButton";
					Name = "R10";
					Position = UDim4.FromUDim2(UDim2.new(0.52,0,0.91,0));
					Size = UDim4.FromUDim2(UDim2.new(0.45, 0, 0.08, 0));	
					BackgroundColor3 = Colors.TribesBlack;
					BackgroundTransparency = 0;
					BorderSizePixel = 1;
					BorderColor3 = Colors.ElementsBlack;		
					Text = " ";
				};
			};
		};
		
		{
			Type = "Frame";
			Name = "InviteSector";
			BackgroundTransparency = 1;
			Position = UDim4.FromUDim2(UDim2.new(.82, -5, 0.515, 0));
			Size = UDim4.FromUDim2(UDim2.new(0.18, 0, 0.16, 0));
			Visible = false;
			
			{
				Type = "Frame";
				Name = "HIDECOL";
				Position = UDim4.FromUDim2(UDim2.new(0,0,0.0,0));
				Size = UDim4.FromUDim2(UDim2.new(0,1,0,1));	
				BackgroundColor3 = Colors.ElementsDarkGrey;
				BackgroundTransparency = 1;
				BorderSizePixel = 1;
			};
			
			{
				Type = "Frame";
				Name = "UpperColoring";
				Position = UDim4.FromUDim2(UDim2.new(0,0,0.0,0));
				Size = UDim4.FromUDim2(UDim2.new(1,0,0.4,0));	
				BackgroundColor3 = Colors.ElementsDarkGrey;
				BackgroundTransparency = 0;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsWhite;
			};
			
			{
				Type = "Frame";
				Name = "LowerColoring";
				Position = UDim4.FromUDim2(UDim2.new(0,0,0.6,0));
				Size = UDim4.FromUDim2(UDim2.new(1,0,0.4,0));	
				BackgroundColor3 = Colors.ElementsDarkGrey;
				BackgroundTransparency = 0;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsWhite;
			};
			
			{
				Type = "TextButton";
				Name = "ACCEPT";
				Position = UDim4.FromUDim2(UDim2.new(0,0,0.4,0));
				Size = UDim4.FromUDim2(UDim2.new(0.5, 0, 0.2, 0));	
				BackgroundColor3 = Colors.ElementsGreen;
				BackgroundTransparency = 0;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsWhite;		
				Text = "ACCEPT";
				Font = Enum.Font.SourceSansBold;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
			};
			
			{
				Type = "TextButton";
				Name = "IGNORE";
				Position = UDim4.FromUDim2(UDim2.new(0.5,0,0.4,0));
				Size = UDim4.FromUDim2(UDim2.new(0.5, 0, 0.2, 0));	
				BackgroundColor3 = Colors.ElementsRed;
				BackgroundTransparency = 0;
				BorderSizePixel = 1;
				BorderColor3 = Colors.ElementsWhite;		
				Text = "IGNORE";
				Font = Enum.Font.SourceSansBold;
				FontSize = Enum.FontSize.Size24;
				TextColor3 = Colors.ElementsBlack;
			};
			
			{
				Type = "TextLabel";
				Name = "UpperConstant";
				Position = UDim4.FromUDim2(UDim2.new(0,0,0,0));
				Size = UDim4.FromUDim2(UDim2.new(1,0,0.2,0));	
				BackgroundTransparency = 1;	
				Font = Enum.Font.SourceSans;
				FontSize = Enum.FontSize.Size18;
				TextColor3 = Colors.ElementsWhite;
				TextWrapped = true;
				Text = "You have been invited to:";
			};	
			
			{
				Type = "TextLabel";
				Name = "LowerConstant";
				Position = UDim4.FromUDim2(UDim2.new(0,0,0.6,0));
				Size = UDim4.FromUDim2(UDim2.new(1,0,0.2,0));	
				BackgroundTransparency = 1;	
				Font = Enum.Font.SourceSans;
				FontSize = Enum.FontSize.Size18;
				TextColor3 = Colors.ElementsWhite;
				TextWrapped = true;
				Text = "This invitation was sent by:";
			};
			
			{
				Type = "TextLabel";
				Name = "LowerVariable";
				Position = UDim4.FromUDim2(UDim2.new(0,0,0.8,0));
				Size = UDim4.FromUDim2(UDim2.new(1,0,0.2,0));	
				BackgroundTransparency = 1;	
				Font = Enum.Font.SourceSans;
				FontSize = Enum.FontSize.Size18;
				TextColor3 = Colors.ElementsWhite;
				TextWrapped = true;
				Text = "ERROR CODE #TS";
			};
			
			{
				Type = "TextLabel";
				Name = "UpperVariable";
				Position = UDim4.FromUDim2(UDim2.new(0,0,0.2,0));
				Size = UDim4.FromUDim2(UDim2.new(1,0,0.2,0));	
				BackgroundTransparency = 1;	
				Font = Enum.Font.SourceSans;
				FontSize = Enum.FontSize.Size18;
				TextColor3 = Colors.ElementsWhite;
				TextWrapped = true;
				Text = "ERROR CODE #TS";
			};
			
		};
	
}	
	