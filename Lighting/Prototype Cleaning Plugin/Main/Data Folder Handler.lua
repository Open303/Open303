function isStringIn(str, list)
	for _, item in pairs(list) do
		if str == item then
			return true
		end
	end
	return false
end

local module = {}

--[[
dataFolder - Either a Data folder from an item/tool/thing or one of the Prototypes inside ReplicatedStorage.Data
badPrototypesList - A list of strings, any prototype that matches this string will be deleted if DESTROY is true.
DESTROY - Whether or not prototypes that match a string in badPrototypes should be deleted.
		Also whether or not ObjectValue Prototypes will be replaced with StringValues.

Returns a count of:
ObjectValue prototypes.
StringValue prototypes.
Prototypes with no value.
Prototypes that match a string in badPrototypesList.
--]]
module.handleData = function(dataFolder, badPrototypesList, DESTROY)
	local objectPrototypes = 0
	local stringPrototypes = 0
	local emptyPrototypes = 0
	local badPrototypes = 0
	for _, child in pairs(dataFolder:GetChildren()) do
		--Object values should be converted to string values, for uniformity (and ease of editing in explorer).
		if child:IsA("ObjectValue") and child.Name == "Prototype" then
			objectPrototypes = objectPrototypes + 1
			if child.Value == nil then
				emptyPrototypes = emptyPrototypes + 1
				warn("Found empty prototype at " .. child:GetFullName())
				if isStringIn("", badPrototypesList) then
					if DESTROY then
						child:Destroy()
					end
					badPrototypes = badPrototypes + 1
				else
					if DESTROY then
						local replacement = Instance.new("StringValue")
						replacement.Name = "Prototype"
						replacement.Value = ""
						replacement.Parent = dataFolder
						child:Destroy()
					end
				end
			else
				if isStringIn(child.Value, badPrototypesList) then
					if DESTROY then
						child:Destroy()
					end
				badPrototypes = badPrototypes + 1
				else
					if DESTROY then
						local replacement = Instance.new("StringValue")
						replacement.Name = "Prototype"
						replacement.Value = child.Value.Name
						replacement.Parent = dataFolder
						child:Destroy()
					end
				end
			end
		elseif child:IsA("StringValue") and child.Name == "Prototype" then
			stringPrototypes = stringPrototypes + 1
			if child.Value == nil or child.Value == "" then
				warn("Empty string prototype at " .. child:GetFullName())
				emptyPrototypes = emptyPrototypes + 1
			elseif isStringIn(child.Value, badPrototypesList) then
				if DESTROY then
					child:Destroy()
				end
				badPrototypes = badPrototypes + 1
			end
		elseif child:IsA("ValueBase") then
			--This includes any data tags like Flammable or HeatsTo or Hunger.
			
		elseif child:IsA("Folder") then
			--recursively go deeper, there's more data values in here!
			local moreObjects, moreStrings, moreEmpty, moreBad = module.handleData(child, badPrototypesList, DESTROY)
			objectPrototypes = objectPrototypes + moreObjects
			stringPrototypes = stringPrototypes + moreStrings
			emptyPrototypes = emptyPrototypes + moreEmpty
			badPrototypes = badPrototypes + moreBad
		else
			warn("Found unusual item in data folder - " .. child.ClassName .. " " .. child:GetFullName())
		end
	end
	if #dataFolder:GetChildren() == 0 then
		if DESTROY then
			dataFolder:Destroy()
		end
	end
	
	return objectPrototypes, stringPrototypes, emptyPrototypes, badPrototypes
end

return module
