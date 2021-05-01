--[[
	Hello, future reader!
	If you need to use this for whatever reason, I'm deeply sorry.
	
	The purpose of this script (which should be run as a plugin) is to clean up the explorer of a lot of
	the crap that was cluttering it up, and also to find bugs caused by missing prototype values.
	
	If you set DESTROY to true and run this as a plugin, it will:
	Find and destroy any weld that connects two anchored parts.
	Find, lists and destroy any ValueObject that isn't inside a Data folder - this cleans up the remains of what I
		can only assume was the previous data handling system that's now obsolete.
		Note that a few get migrated, namely TYPE and RARITY - these (unlike the others) are still in use.
		I've updated the scripts that use them to use the proper DataAccessor route.
	Finds and converts any prototype that is an ObjectValue.
		StringValues are better, because they don't sneakily erase themselves if you look at them funny.
	Finds and notifies you of any prototype that is empty.
	
	You can run this as a regular script to see how much damage it plans on doing.
	
	I'm keeping this in Lighting because it may be salvageable - one day, I'd like to convert this into
	a set of unit tests, including bonus cool tests like "do the StringValue prototypes actually go anywhere".
]]--

local DESTROY = false

local dataHandler = require(script["Data Folder Handler"])
	
local badPrototypes = 0
local emptyPrototypes = 0
local stringPrototypes = 0
local objectPrototypes = 0
local badWelds = 0
local snaps = 0
local parts = 0
local listOfOldDataValues = {}

local badPrototypeValues = {
}

function isStringIn(str, list)
	for _, item in pairs(list) do
		if str == item then
			return true
		end
	end
	return false
end

--[[
Finds (and destroys if DESTROY) any prototypes with a value in badPrototypes.
Adds all prototypes found to the count.
--]]
function handleData(dataFolder, badPrototypesList)
	local o, s, e, b = dataHandler.handleData(dataFolder, badPrototypesList, DESTROY)
	objectPrototypes = objectPrototypes + o
	stringPrototypes = stringPrototypes + s
	emptyPrototypes = emptyPrototypes + e
	badPrototypes = badPrototypes + b
end

local oldDataValuesToMigrate = {
"Quarryable",
"RARITY",
"TYPE",
"NORESPAWN"
}

--[[
	This function takes a data value, and either moves it into the Data folder if it's still in use,
	or just deletes it outright if it's not.
	Special handling for Quarryable, which is transformed into a new Prototype.
	Also mantains the listOfOldDataValues and the badPrototypes count.
--]]
function handleOldDataValue(dataValue)
	badPrototypes = badPrototypes + 1
	if not isStringIn(dataValue.Name, listOfOldDataValues) then
		table.insert(listOfOldDataValues, dataValue.Name)
	end
	if not DESTROY then return end
	if not isStringIn(dataValue.Name, oldDataValuesToMigrate) then
		dataValue:Destroy()
	else
		local dataFolder = dataValue.Parent:FindFirstChild("Data")
		if dataFolder == nil then
			dataFolder = Instance.new("Folder")
			dataFolder.Name = "Data"
			dataFolder.Parent = dataValue.Parent
		end
		if dataValue.Name == "Quarryable" then
			dataValue:Destroy()
			local newPrototype = Instance.new("StringValue")
			newPrototype.Name = "Prototype"
			newPrototype.Value = "Quarryable World Block"
			newPrototype.Parent = dataFolder
		else
			dataValue.Parent = dataFolder
		end
	end
end

--[[
	Takes a part.
	Looks for outdated data tags (ValueObjects outside of Data Folders), or welds that don't do anything.
	These are destroyed if DESTROY.
--]]
function handlePart(part)
	parts = parts + 1
	if parts % 1000 == 0 then
		print("Scanned " .. parts .. " parts.")
	end
	for _, grandChild in pairs(part:GetChildren()) do
		if grandChild:IsA("JointInstance") then
			--joints between two anchored parts are redundant
			--joints containing a nil are also redundant
			if ((grandChild.Part0 == nil or grandChild.Part1 == nil)
			or (grandChild.Part0.Anchored and grandChild.Part1.Anchored)) then
				badWelds = badWelds + 1
				if grandChild:IsA("Snap") then
					snaps = snaps + 1
				end
				if DESTROY then
					grandChild:Destroy()
				end
			end
		elseif grandChild:IsA("Folder") and grandChild.Name == "Data" then
			handleData(grandChild, badPrototypeValues)
		elseif grandChild:IsA("ValueBase") then
			handleOldDataValue(grandChild)
		end
	end
end

function iterateThrough(parent)
	wait()
	for _, child in pairs(parent:GetChildren()) do
		--model
		if child:IsA("Model") or child:IsA("Tool") or (child:IsA("Folder") and child.Name ~= "Data") then
			iterateThrough(child)
		--part
		elseif child:IsA("BasePart") then
			handlePart(child)
		--data
		elseif child:IsA("Folder") and child.Name == "Data" then
			handleData(child, badPrototypeValues)
		--stinky old data values
		elseif child:IsA("ValueBase") and not parent:IsA("Folder") then
			handleOldDataValue(child)
		end
	end
end

function statusReport()
	print("Scanned " .. parts .. " parts.")
	print("Found " .. objectPrototypes .. " ObjectValue prototypes.")
	print("Found " .. stringPrototypes .. " StringValue prototypes.")
	print("Found " .. emptyPrototypes .. " nil or empty prototypes.")
	print("Found " .. badPrototypes .. " prototypes that were marked as bad.")
	print("Found " .. badWelds .. " bad welds, of which " .. badWelds - snaps .. " were non-snap welds.")
	print("Found the following old data values:")
	for _, item in pairs(listOfOldDataValues) do
		print(item)
	end
end

function resetCounters()
	parts = 0
	objectPrototypes = 0
	stringPrototypes = 0
	emptyPrototypes = 0
	badPrototypes = 0
	badWelds = 0
	snaps = 0
	listOfOldDataValues = {}
end

local thingsToIterateThrough = {
	workspace.Animals,
	workspace.Regions,
	workspace.Islands,
	workspace.Resources,
	workspace.StartupObjects,
	game.ReplicatedStorage.Items,
	game.ReplicatedStorage.Fish,
	game.ReplicatedStorage.Constructables,
	game.ReplicatedStorage.Plants,
	game.ReplicatedStorage.HolidayItems
}

print("Starting...")
for _, thing in pairs(thingsToIterateThrough) do
	warn("Iterating through: " .. thing:GetFullName())
	iterateThrough(thing)
end


warn("Iterating through prototypes.")
for _, folder in pairs(game.ReplicatedStorage.Data.Prototypes:GetChildren()) do
	handleData(folder, badPrototypeValues, DESTROY)
end
statusReport()

if DESTROY then
	print("AND I DESTROYED THEM ALL")
	print("well, the bad stuff")
end