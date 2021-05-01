local localPlayer = game.Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local boundsCheck = Instance.new("ScreenGui", playerGui)
local testLabel = Instance.new("TextLabel", boundsCheck)
testLabel.Visible = false
testLabel.TextWrapped = true

return function(text, font, fontSize, containerBounds)
	containerBounds = containerBounds or UDim2.new(0, math.huge, 0, math.huge)
	
	testLabel.Font = font
	testLabel.FontSize = fontSize
	testLabel.Text = text
	
	return testLabel.TextBounds
end