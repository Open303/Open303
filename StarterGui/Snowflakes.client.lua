

----------
local Debris = game:GetService("Debris")
--local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local UDim4 = Load "UI.UDim4"
local Colors = Load "UI.Colors"
local DataAccessor = Load "Data.DataAccessor"
local Scaffold = Load "UI.Scaffolder"

--local Api = game:GetService("ReplicatedStorage"):WaitForChild("Api")
--local SafeEdit = Api:WaitForChild("SafeEdit")

wait(1)

local PlayerGui = player:WaitForChild("PlayerGui")
local gui = Instance.new("ScreenGui", PlayerGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(1,0,1,0)
frame.BackgroundTransparency = 1
frame.Name = "WeatherFrame"

local Iframe = Instance.new("Frame", frame)
Iframe.Size = UDim2.new(1,0,1,0)
Iframe.BackgroundTransparency = 1
Iframe.Name = "InnerFrame"

while not player.Character do wait(1) end

local Button = Instance.new("TextButton", frame)
Button.Name = "ToggleButton"
Button.BackgroundColor3 = Colors.Red
Button.Text = "Toggle Snowflake Effects"	

Button.BorderSizePixel = 1
Button.BorderColor3 = Colors.White
Button.TextColor3 = Colors.White

Button.Position = UDim2.new(0, 5, .91, -10);
Button.Size = UDim2.new(0.15, 0, 0.03, 0);

local snowON = true


local Snowflakes = {
	"rbxassetid://195363535";
	"rbxassetid://195363680";
	"rbxassetid://195363795";
	"rbxassetid://195363944";	
}


local function createSnowflake()
	local XPos = math.random()
	local Size = math.random(8, 14)

	local lifetime = 9-(Size/11)*6

	local droplet = Instance.new("ImageLabel", frame.InnerFrame)
	droplet.BackgroundTransparency = 1
	droplet.Size = UDim2.new(0,Size,0,Size)
	droplet.Position = UDim2.new(XPos,0,0,0)
	droplet.BorderSizePixel = 0
	droplet.Name = "snow"
	droplet.Image = Snowflakes[math.random(#Snowflakes)]
	droplet:TweenPosition(UDim2.new(XPos,0,1,0), "Out", "Linear", lifetime)

	Debris:AddItem(droplet, lifetime)
end

local function ToggleGui()
	snowON = not snowON
	print "flipped"
	if snowON == false then
		frame.InnerFrame.Visible = false
	
		
	else
	frame.InnerFrame.Visible = true
	end
end



Button.InputEnded:connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		ToggleGui()
		
		--print("SERVERCODE: #Filter2")  --[[for testing purposes alone]]
	end
end)



while true do
	
	createSnowflake()
	wait(.09)
end






