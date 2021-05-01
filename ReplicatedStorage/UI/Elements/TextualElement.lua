local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local Element = Load "UI.Elements.Element"

local TextualElement = {}
setmetatable(TextualElement, { __index = Element })
TextualElement.ClassName = "TextualElement"
TextualElement.__index = Element.__index
TextualElement.__newindex = Element.__newindex

function TextualElement.new(robloxObject)
	local self = setmetatable(Element.new(robloxObject), TextualElement)
	self.MaximumFontSize = Enum.FontSize.Size96
	self.MinimumFontSize = Enum.FontSize.Size8
	
	robloxObject.Changed:connect(function(property)
		if property == "AbsoluteSize" then
			self:_updateFontSize()
		end
	end)
	
	return self
end

-- Properties
do
	function TextualElement:get_Font()
		return self._robloxObject.Font
	end
	
	function TextualElement:set_Font(value)
		self._robloxObject.Font = value
		self:_updateFontSize()
	end
	
	function TextualElement:get_FontSize()
		return self._robloxObject.FontSize
	end
	
	function TextualElement:set_FontSize(value)
		self.TextScaled = false
		self._robloxObject.FontSize = value
	end
	
	function TextualElement:get_MaximumFontSize()
		return self._maximumFontSize
	end
	
	function TextualElement:set_MaximumFontSize(value)
		self.TextScaled = true;
		self._maximumFontSize = value
		self:_updateFontSize()
	end
	
	function TextualElement:get_MinimumFontSize()
		return self._minimumFontSize
	end
	
	function TextualElement:set_MinimumFontSize(value)
		self.TextScaled = true;
		self._minimumFontSize = value
		self:_updateFontSize()
	end
	
	function TextualElement:get_Text()
		return self._robloxObject.Text
	end
	
	function TextualElement:set_Text(value)
		self._robloxObject.Text = value
		self:_updateFontSize()
	end
	
	function TextualElement:get_TextBounds()
		return self._robloxObject.TextBounds
	end
	
	function TextualElement:get_TextColor3()
		return self._robloxObject.TextColor3
	end
	
	function TextualElement:set_TextColor3(value)
		self._robloxObject.TextColor3 = value
	end
	
	function TextualElement:get_TextFits()
		return self._robloxObject.TextFits
	end
	
	function TextualElement:get_TextScaled()
		return self._textScaled
	end
	
	function TextualElement:set_TextScaled(value)
		assert(type(value) == "boolean", "TextualElement.TextScaled is a boolean")
		self._textScaled = value
		self:_updateFontSize()
	end
	
	function TextualElement:get_TextStrokeColor3()
		return self._robloxObject.TextStrokeColor3
	end
	
	function TextualElement:set_TextStrokeColor3(value)
		self._robloxObject.TextStrokeColor3 = value
	end
	
	function TextualElement:get_TextStrokeTransparency()
		return self._robloxObject.TextStrokeTransparency
	end
	
	function TextualElement:set_TextStrokeTransparency(value)
		self._robloxObject.TextStrokeTransparency = value
	end
	
	function TextualElement:get_TextTransparency()
		return self._robloxObject.TextTransparency
	end
	
	function TextualElement:set_TextTransparency(value)
		self._robloxObject.TextTransparency = value
	end
	
	function TextualElement:get_TextWrapped()
		return self._robloxObject.TextWrapped
	end
	
	function TextualElement:set_TextWrapped(value)
		self._robloxObject.TextWrapped = value
	end
	
	function TextualElement:get_TextXAlignment()
		return self._robloxObject.TextXAlignment
	end
	
	function TextualElement:set_TextXAlignment(value)
		self._robloxObject.TextXAlignment = value
	end
	
	function TextualElement:get_TextYAlignment()
		return self._robloxObject.TextYAlignment
	end
	
	function TextualElement:set_TextYAlignment(value)
		self._robloxObject.TextYAlignment = value
	end
end

function TextualElement:_updateFontSize()
	if not self._textScaled then
		return
	end
	
	if self._maximumFontSize == nil or self._minimumFontSize == nil then return end
	
	local current = self._maximumFontSize.Value
	local min = self._minimumFontSize.Value
	self._robloxObject.FontSize = current
	
	while not self.TextFits do
		if current == 0 or current == min then
			break
		else
			current = current - 1
		end
		
		self._robloxObject.FontSize = current
	end
end

return TextualElement