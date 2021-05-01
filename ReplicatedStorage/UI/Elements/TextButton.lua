local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local Create = Load "Create"
local TextualElement = Load "UI.Elements.TextualElement"

local TextButton = {}
setmetatable(TextButton, { __index = TextualElement })
TextButton.ClassName = "TextView"
TextButton.__index = TextualElement.__index
TextButton.__newindex = TextualElement.__newindex

function TextButton.new()
	local robloxObject = Create "TextButton" {
		Name = "TextButton";
		BackgroundTransparency = 1;
		Font = Enum.Font.SourceSans;
		FontSize = Enum.FontSize.Size18;
		Text = "TextButton";
		TextColor3 = Color3.new(1, 1, 1);
		TextScaled = false;
		TextWrapped = true;
	}
	
	local self = setmetatable(TextualElement.new(robloxObject), TextButton)
	return self
end

-- Properties
do
	function TextButton:get_ClearTextOnFocus()
		return self._robloxObject.ClearTextOnFocus
	end
	
	function TextButton:set_ClearTextOnFocus(value)
		self._robloxObject.ClearTextOnFocus = value
	end
	
	function TextButton:get_MultiLine()
		return self._robloxObject.MultiLine
	end
	
	function TextButton:set_MultiLine(value)
		self._robloxObject.MultiLine = value
	end
	
	function TextButton:get_Focused()
		return self._robloxObject:IsFocused()
	end
	
	function TextButton:get_Focused()
		return self._robloxObject.Focused
	end
	
	function TextButton:get_FocusLost()
		return self._robloxObject.FocusLost
	end
end

function TextButton:CaptureFocus()
	self._robloxObject:CaptureFocus()
end

function TextButton:ReleaseFocus(submitted)
	self._robloxObject:ReleaseFocus(submitted)
end

return TextButton