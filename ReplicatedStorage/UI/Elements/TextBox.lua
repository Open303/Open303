local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local Create = Load "Create"
local TextualElement = Load "UI.Elements.TextualElement"

local TextBox = {}
setmetatable(TextBox, { __index = TextualElement })
TextBox.ClassName = "TextView"
TextBox.__index = TextualElement.__index
TextBox.__newindex = TextualElement.__newindex

function TextBox.new()
	local robloxObject = Create "TextBox" {
		Name = "TextBox";
		BackgroundTransparency = 1;
		Font = Enum.Font.SourceSans;
		FontSize = Enum.FontSize.Size18;
		Text = "TextBox";
		TextColor3 = Color3.new(1, 1, 1);
		TextScaled = false;
		TextWrapped = true;
	}
	
	local self = setmetatable(TextualElement.new(robloxObject), TextBox)
	return self
end

-- Properties
do
	function TextBox:get_ClearTextOnFocus()
		return self._robloxObject.ClearTextOnFocus
	end
	
	function TextBox:set_ClearTextOnFocus(value)
		self._robloxObject.ClearTextOnFocus = value
	end
	
	function TextBox:get_MultiLine()
		return self._robloxObject.MultiLine
	end
	
	function TextBox:set_MultiLine(value)
		self._robloxObject.MultiLine = value
	end
	
	function TextBox:get_Focused()
		return self._robloxObject:IsFocused()
	end
	
	function TextBox:get_Focused()
		return self._robloxObject.Focused
	end
	
	function TextBox:get_FocusLost()
		return self._robloxObject.FocusLost
	end
end

function TextBox:CaptureFocus()
	self._robloxObject:CaptureFocus()
end

function TextBox:ReleaseFocus(submitted)
	self._robloxObject:ReleaseFocus(submitted)
end

return TextBox