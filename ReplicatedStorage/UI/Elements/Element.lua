local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local Class = Load "Utility.Class"
local UDim4 = Load "UI.UDim4"

local UserInputService = game:GetService("UserInputService")

local Element = {}
setmetatable(Element, { __index = Class })
Element.ClassName = "Element"
Element.__index = Class.__index
Element.__newindex = Class.__newindex

function Element.new(robloxObject)
	assert(pcall(game.IsA, robloxObject, "GuiObject") and robloxObject:IsA("GuiObject"), "Element.new: robloxObject(1) must be a GuiObject")
	local self = setmetatable(Class.new(), Element)
	self.Children = {}
	self.RobloxObject = robloxObject
	self.Position = UDim4.new(UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0))
	self.Size = UDim4.new(UDim2.new(0, 100, 0, 0), UDim2.new(0, 100, 0, 0))
	
	UserInputService.Changed:connect(function(property)
		if property == "ViewportSize" then
			self:_recomputePositionAndSize()
		end
	end)
	
	return self
end

function Element._forward(class, name, readonly)
	class["get_"..name] = function(self)
		return self._robloxObject[name]
	end
	
	if not readonly then
		class["set_"..name] = function(self, value)
			self._robloxObject[name] = value
		end
	end
end

-- Properties
do
	Element._forward(Element, "AbsoluteSize", true)
	Element._forward(Element, "AbsolutePosition", true)
	Element._forward(Element, "Active")
	Element._forward(Element, "BackgroundTransparency")
	Element._forward(Element, "BorderSizePixel")
	Element._forward(Element, "ClipsDescendants")
	Element._forward(Element, "Rotation")
	Element._forward(Element, "Visible")
	Element._forward(Element, "ZIndex")
	Element._forward(Element, "InputBegan", true)
	Element._forward(Element, "InputChanged", true)
	Element._forward(Element, "InputEnded", true)
	Element._forward(Element, "MouseEnter", true)
	Element._forward(Element, "MouseLeave", true)
	Element._forward(Element, "MouseMoved", true)
	
	function Element:get_BackgroundColor3()
		return self._backgroundColor
	end
	
	function Element:set_BackgroundColor3(value)
		self._backgroundColor = value
		self._robloxObject.BackgroundColor3 = value
	end
	
	function Element:get_BorderColor3()
		return self._borderColor
	end
	
	function Element:set_BorderColor3(value)
		self._borderColor = value
		self._robloxObject.BorderColor3 = value
	end
	
	function Element:get_Name()
		return self._name
	end
	
	function Element:set_Name(value)
		self._robloxObject.Name = value
		self._name = value
	end
	
	function Element:get_Position()
		return self._position
	end
	
	function Element:set_Position(value)
		self._position = value
		self:_recomputePositionAndSize()
	end
	
	function Element:get_RobloxObject()
		return self._robloxObject
	end
	
	function Element:set_RobloxObject(value)
		if self._robloxObject == nil then
			self._robloxObject = value
		else
			error("Element.RobloxObject may only be set once")
		end
	end
	
	function Element:get_Size()
		return self._size
	end
	
	function Element:set_Size(value)
		self._size = value
		self:_recomputePositionAndSize()
	end
end

-- Methods
do
	function Element:_recomputePositionAndSize()
		local parent = self._parent
		
		if parent == nil then
			return
		end
		
		local absoluteSize = parent.AbsoluteSize
		local robloxObject = self._robloxObject
		
		local position = self.Position:ToAbsolute(absoluteSize)
		local size = self.Size:ToAbsolute(absoluteSize)
		
		robloxObject.Position = UDim2.new(0, position.X, 0, position.Y)
		robloxObject.Size = UDim2.new(0, size.X, 0, size.Y)
	end
	
	function Element:Destroy()
		self.Parent = nil
		self._robloxObject:Destroy()
	end
	
	function Element:_parentChangeCallback(value)
		if self._parentConnection and self._parentConnection.connected then
			self._parentConnection:disconnect()
		end
		
		if value == nil or value:IsA("GuiBase2d") then
			self._robloxObject.Parent = value
		else
			self._robloxObject.Parent = value.RobloxObject
		end
		
		if value ~= nil then
			self:_recomputePositionAndSize()
			self._parentConnection = self._robloxObject.Parent.Changed:connect(function(property)
				if property == "AbsoluteSize" then
					self:_recomputePositionAndSize()
				end
			end)
		end
	end
end

return Element