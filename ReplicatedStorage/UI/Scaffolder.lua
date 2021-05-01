local Load = require(game.ReplicatedStorage:WaitForChild("Load"))

local mappings = {
	Button = Load "UI.Elements.Button".new;
	TextView = Load "UI.Elements.TextView".new;
	TextBox = Load "UI.Elements.TextBox".new;
	TextButton = Load "UI.Elements.TextButton".new;
	TextLabel = Load "UI.Elements.TextLabel".new;
	ScrollingFrame = Load "UI.Elements.ScrollingFrame".new;
	ImageView = Load "UI.Elements.ImageView".new;
	Frame = Load "UI.Elements.Frame".new;
	Bar = Load "UI.Elements.Bar".new;
	Dropdown = Load "UI.Elements.Dropdown".new;
}

local scaffoldBin = Load "UI.Scaffolds"

local specialProcessed = {
	Type = true;
	Children = true;
}

local function Build(uiTable, parameters)
	parameters = parameters or {}
	
	local objectType = uiTable.Type
	local scaffoldType = uiTable.Scaffold
	
	if objectType ~= nil and scaffoldType ~= nil then
		error("An object may not contain both a Type and Scaffold key.")
	end
	
	local object
	
	if objectType ~= nil then
		local ctor = mappings[objectType]
		
		if ctor == nil then
			error("Scaffolder doesn't know how to create a "..tostring(objectType))
		else
			object = ctor()
		end
	elseif scaffoldType ~= nil then
		local scaffold = scaffoldBin:WaitForChild(scaffoldType, 0.5)
		
		if scaffold == nil then
			error("Scaffolder can't find a scaffold named "..tostring(scaffoldType))
		else
			object = Build(require(scaffold), setmetatable(parameters, { __index = uiTable }))
			setmetatable(parameters, nil)
		end
	end
	
	for key, value in pairs(uiTable) do
		if not specialProcessed[key] then
			if type(value) == "string" then
				local parameter = value:match("^%s*@(%w+)%s*$")
				if parameter ~= nil then
					value = parameters[parameter]
				end
			end
			
			if type(key) == "number" then
				local result = Build(value, parameters)
				result.Parent = object
			else
				object[key] = value
			end
		end
	end
	
	return object
end

return Build