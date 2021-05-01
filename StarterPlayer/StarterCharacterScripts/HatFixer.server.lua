local properties = PhysicalProperties.new(
	0.001,
	0,
	0
)

local function NerfHat(hat)
	for _, child in ipairs(hat:GetChildren()) do
		if child:IsA("BasePart") then
			child.CustomPhysicalProperties = properties
		end
	end
end

for _, object in ipairs(script.Parent:GetChildren()) do
	if object:IsA("Accoutrement") then
		NerfHat(object)
	end
end

script.Parent.ChildAdded:Connect(function(child)
	if child:IsA("Accoutrement") then
		NerfHat(child)
	end
end)