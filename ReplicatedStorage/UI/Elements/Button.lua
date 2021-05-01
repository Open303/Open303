local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local Create = Load "Create"
local Element = Load "UI.Elements.Element"
local FunctionRunner = Load "Animation.FunctionRunner"

local Button = {}
setmetatable(Button, { __index = Element })
Button.ClassName = "Button"
Button.__index = Element.__index
Button.__newindex = Element.__newindex

function Button.new()
	local robloxObject = Create "TextButton" {
		Name = "Button";
		AutoButtonColor = false;
		BackgroundColor3 = Color3.new(1, 1, 1);
		BorderSizePixel = 0;
		Text = "";
		TextStrokeTransparency = 1;
		TextTransparency = 1;
	}
	
	local self = setmetatable(Element.new(robloxObject), Button)
	self.AutoButtonColor = true
	self.BackgroundColor3 = Color3.new(1, 1, 1)
	
	self._mouseOver = false
	self._mouseDown = false
	self._lastColor = self.BackgroundColor3
	self._goalColor = self.BackgroundColor3
	self._animationRunner = FunctionRunner.new(function(alpha)
		local intermediary = self._lastColor:lerp(self._goalColor, alpha)
		robloxObject.BackgroundColor3 = intermediary
		
		if alpha == 1 then
			self._animatingChange = false
		end
	end, 0.075)
	
	robloxObject.MouseEnter:connect(function()
		self._mouseOver = true
		self:_restartFade()
	end)
	
	robloxObject.MouseLeave:connect(function()
		self._mouseOver = false
		self._mouseDown = false
		self:_restartFade()
	end)
	
	robloxObject.MouseButton1Down:connect(function()
		self._mouseDown = true
		self:_restartFade()
	end)
	
	robloxObject.MouseButton1Up:connect(function()
		self._mouseDown = false
		self:_restartFade()
	end)
	
	return self
end

function Button:_restartFade()
	self._lastColor = self._robloxObject.BackgroundColor3
	self._goalColor = self:_getGoalColor()
	
	if self.AutoButtonColor then
		self._animatingChange = true
		self._animationRunner:RestartAsync()
	end
end

function Button:_getGoalColor()
	local goal = self._backgroundColor
	
	if self.AutoButtonColor then
		if self._mouseDown then
			goal = self._pressColor
		elseif self._mouseOver then
			goal = self._hoverColor
		end
	end
	
	return goal
end

function Button:set_BackgroundColor3(value)
	self._backgroundColor = value
	local h, s, v = Color3.toHSV(value)
	
	self._hoverColor = Color3.fromHSV(h, s, math.min(1, v + 0.1))
	self._pressColor = Color3.fromHSV(h, s, math.max(0, v - 0.1))
	
	if not self._animatingChange then
		self._robloxObject.BackgroundColor3 = self:_getGoalColor()
	end
end

return Button