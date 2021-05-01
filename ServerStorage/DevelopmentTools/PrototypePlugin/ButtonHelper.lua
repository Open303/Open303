----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local Create = Load "Create"

----------------------------------------
----- Main Module ----------------------
----------------------------------------
local ButtonHelper = {}

function ButtonHelper.SetupAutoColor(button)
	assert(button:IsA("ImageButton"), "button must be an ImageButton")
	
	local hover = button:FindFirstChild("Hover")
	local click = button:FindFirstChild("Click")
	
	if not hover then
		hover = Create "ImageLabel" {
			Name = "Hover";
			Parent = button;
			BackgroundTransparency = 1;
			Size = UDim2.new(1, 0, 1, 0);
			Visible = false;
			Image = button.Image;
			ImageColor3 = Color3.new(1, 1, 1);
			ImageTransparency = 0.8;
			ScaleType = button.ScaleType;
			SliceCenter = button.SliceCenter;
		}
	end
	
	if not click then
		click = hover:Clone()
		click.Name = "Click"
		click.Parent = button
		click.ImageColor3 = Color3.new(0, 0, 0)
	end
	
	local mouseOver, mouseDown = false, false
	
	local function Update()
		if mouseDown then
			hover.Visible = false
			click.Visible = true
		elseif mouseOver then
			hover.Visible = true
			click.Visible = false
		else
			hover.Visible = false
			click.Visible = false
		end
	end
	
	button.MouseEnter:connect(function()
		mouseOver = true
		Update()
	end)
	
	button.MouseLeave:connect(function()
		mouseOver = false
		Update()
	end)
	
	button.MouseButton1Down:connect(function()
		mouseDown = true
		Update()
	end)
	
	button.MouseButton2Down:connect(function()
		mouseDown = true
		Update()
	end)
	
	button.MouseButton1Up:connect(function()
		mouseDown = false
		Update()
	end)
	
	button.MouseButton2Up:connect(function()
		mouseDown = false
		Update()
	end)
end

return ButtonHelper