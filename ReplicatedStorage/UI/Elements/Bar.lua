local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local Frame = Load "UI.Elements.Frame"
local UDim4 = Load "UI.UDim4"

local Bar = {}
setmetatable(Bar, { __index = Frame })
Bar.ClassName = "Bar"
Bar.__index = Frame.__index
Bar.__newindex = Frame.__newindex

Bar.Anchors = {
	Start = 0;
	Middle = 1;
	End = 2;
}

Bar.Axes = {
	Horizontal = 0;
	Vertical = 1;
	Both = 2;
}

function Bar.new()
	local self = setmetatable(Frame.new(), Bar)
	
	self.ClipsDescendants = true
	self.RealBar = Frame.new()
	self.RealBar.Parent = self
	self.RealBar.BackgroundColor3 = Color3.new(0, 0, 1)
	
	self.Anchor = Bar.Anchors.Start
	self.Axis = Bar.Axes.Horizontal
	self.Percent = 0
	
	return self
end

-- Properties
do
	function Bar:get_Anchor()
		return self._anchor
	end
	
	function Bar:set_Anchor(value)
		if type(value) == "string" then
			if Bar.Anchors[value] == nil then
				error(value.." is not a valid Anchor")
			end

			value = Bar.Anchors[value]
		end
		
		self._anchor = value
		self:_updateRealBar()
	end
	
	function Bar:get_Axis()
		return self._axis
	end
	
	function Bar:set_Axis(value)
		if type(value) == "string" then
			if Bar.Axes[value] == nil then
				error(value.." is not a valid Axis")
			end
			
			value = Bar.Axes[value]
		end
		
		self._axis = value
		self:_updateRealBar()
	end
	
	function Bar:get_BarColor3()
		return self.RealBar.BackgroundColor3
	end
	
	function Bar:set_BarColor3(value)
		self.RealBar.BackgroundColor3 = value
	end
	
	function Bar:get_Percent()
		return self._percent
	end
	
	function Bar:set_Percent(value)
		self._percent = value
		self:_updateRealBar()
	end
end

function Bar:_updateRealBar()
	local anchor = self._anchor
	local axis = self._axis
	local percent = self._percent
	
	if anchor == nil or axis == nil or percent == nil then return end
	
	local anchorPoint = anchor / 2 - percent * (anchor / 2)
	local position, size
	
	if axis == Bar.Axes.Both then
		position = UDim4.new(anchorPoint, 0, anchorPoint, 0)
		size = UDim4.new(percent, 0, percent, 0)
	elseif axis == Bar.Axes.Horizontal then
		position = UDim4.new(anchorPoint, 0, 0, 0)
		size = UDim4.new(percent, 0, 1, 0)
	elseif axis == Bar.Axes.Vertical then
		position = UDim4.new(0, 0, anchorPoint, 0)
		size = UDim4.new(1, 0, percent, 0)
	end
	
	self.RealBar.Position = position
	self.RealBar.Size = size
end

return Bar