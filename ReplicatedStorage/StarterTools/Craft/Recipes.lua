----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))

----------------------------------------
----- Objects --------------------------
----------------------------------------
local itemRoot = Load "Items"
local constructableRoot = Load "Constructables"

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function Recipe(ingredients, result, quantity, craftingStation, tagline, displayName)
	quantity = quantity or 1
	local resultObject = itemRoot:WaitForChild(result)
	
	if displayName == nil then
		displayName = result
		
		if quantity > 1 then
			displayName = quantity.."x "..displayName
		end
	end
	
	table.sort(ingredients, function(a, b)
		return a:lower() < b:lower()
	end)
	
	local ingredientCounts = {}
	
	for _, ingredient in ipairs(ingredients) do
		local current = ingredientCounts[ingredient] or 0
		ingredientCounts[ingredient] = current + 1
	end
	
	local ingredientStrings = {}
		
	for ingredient, quantity in pairs(ingredientCounts) do
		table.insert(ingredientStrings, tostring(quantity).."x "..ingredient)
	end
	
	local ingredientString = table.concat(ingredientStrings, ", ")
	
	local category = "Items"
	
	if resultObject:IsA("Tool") then
		if constructableRoot:FindFirstChild(result) ~= nil then
			category = "Constructables"
		else
			category = "Tools"
		end
	end
	
	return {
		DisplayName = displayName;
		Tagline = tagline;
		Category = category;
		CraftingStation = craftingStation;
		Ingredients = ingredientCounts;
		IngredientString = ingredientString;
		Result = resultObject;
		Quantity = quantity;
	}
end

----------------------------------------
----- Recipes --------------------------
----------------------------------------
return {

	--[[	Organized by crafting station, mostly alphabetical    ]]
		
	
-- "STRUCTURES"

	--N/A
	Recipe({"Small Tree Stump", "Small Tree Stump", "Cut Stone"}, "Primitive Design Table", 1, nil, "Unlocks simple crafting for tools and items");
	Recipe({"Small Tree Stump", "Small Tree Stump", "Small Stone", "Large Leaves"}, "Stone Workshop", 1, nil,"Unlocks simple crafting for buildings");
	
	--STONE WORKSHOP
	Recipe({"Wall", "Wall", "Wall", "Small Tree Stump"}, "Dock", 1, "Stone Workshop", "Unlocks basic shipbuilding options");
	Recipe({"Small Tree Stump", "Small Tree Stump", "Refined Iron", "Large Leaves"}, "Iron Workshop", 1, "Stone Workshop", "Unlocks additional crafting for buildings");
	Recipe({"Small Tree Stump", "Small Leaves"}, "Wood Compost Bin", 1, "Stone Workshop", "Unlocks basic farming options");
	--crafting stations above
	Recipe({"Wall", "Wall", "Small Tree Stump", "Small Tree Stump"}, "Hollow Palisade Tower", 1, "Stone Workshop");
	Recipe({"Wall", "Wall", "Large Leaves"}, "Hut", 1, "Stone Workshop");
	Recipe({"Small Tree Stump", "Small Tree Stump", "Small Tree Stump"}, "Ladder", 1, "Stone Workshop");
	Recipe({"Wall", "Wall", "Wall", "Wall", "Large Leaves", "Large Leaves"}, "Longhouse", 1, "Stone Workshop");
	Recipe({"Wall", "Wall", "Wall"}, "Palisade Gate", 1, "Stone Workshop");
	Recipe({"Wall", "Wall"}, "Palisade Half-Wall", 1, "Stone Workshop");
	Recipe({"Wall", "Wall", "Wall"}, "Palisade Tower", 1, "Stone Workshop");
	Recipe({"Wall", "Wall", "Wall"}, "Palisade Wall", 1, "Stone Workshop");
	Recipe({"Small Tree Stump", "Small Tree Stump", "Small Tree Stump", "Small Tree Stump", "Large Leaves"}, "Pavillion", 1, "Stone Workshop");
	Recipe({"Wall"}, "Structure Wall", 1, "Stone Workshop");
	Recipe({"Wall", "Wall"}, "Thick Structure Wall", 1, "Stone Workshop");
	Recipe({"Small Tree Stump", "Small Tree Stump", "Large Leaves"}, "Simple Tower", 1, "Stone Workshop");
	Recipe({"Medium Handle", "Hemp"}, "Hemp Lightpost", 1, "Stone Workshop");
--	Recipe({"Small Tree Stump", "Large Leaves", "Glass", "Glass"}, "Holiday Tree", 1, "Stone Workshop");
 
	--IRON WORKSHOP
	Recipe({"Stone Slab", "Small Bush Stump", "Small Bush Stump", "Iron Gear"}, "Coin Press", 1, "Iron Workshop", "Unlocks the ability to craft gold coins");
	Recipe({"Stone Wall", "Stone Wall", "Refined Iron", "Refined Iron", "Thatching"}, "Forge", 1, "Iron Workshop", "Unlocks basic metalworking options");
	Recipe({"Wall", "Wall", "Wall", "Boulder", "Refined Iron", "Iron Gear", "Fabric"}, "Lumbermill", 1, "Iron Workshop", "Unlocks planks and woodchips to craft");
	Recipe({"Stone Wall", "Stone Wall", "Plank", "Plank", "Boulder", "Iron Gear", "Fabric"}, "Mill", 1, "Iron Workshop", "Unlocks flour and cornmeal to craft");
	Recipe({"Plank", "Plank", "Refined Iron"}, "Culinary Table", 1, "Iron Workshop", "Unlocks a variety of culinary options");
	Recipe({"Plank", "Plank", "Plank", "Refined Iron"}, "Quality Design Table", 1, "Iron Workshop", "Unlocks advanced crafting for tools and items");
	Recipe({"Stone Wall", "Plank", "Refined Steel", "Thatching"}, "Steel Workshop", 1, "Iron Workshop", "Unlocks advanced crafting for buildings");
	Recipe({"Refined Iron", "Large Leaves"}, "Iron Compost Bin", 1, "Iron Workshop", "Unlocks advanced farming options");
	--crafting stations above
	Recipe({"Prickly Pear Leaf", "Prickly Pear Leaf", "Prickly Pear Leaf", "Prickly Pear Leaf"}, "Cacti Wall", 1, "Iron Workshop");
--	Recipe({"Refined Iron", "Refined Iron", "Refined Iron", "Small Stone"}, "Cauldron", 1, "Iron Workshop");
	Recipe({"Small Bush Stump", "Small Stick", "Nest", "Egg"}, "Chicken Coup", 1, "Iron Workshop");
--	Recipe({"Plank", "Plank", "Plank", "Iron Gear", "Glass"}, "Dye Maker", 1, "Iron Workshop");
	Recipe({"Large Handle", "Fabric", "Fabric"}, "Flag", 1, "Iron Workshop");
	Recipe({"Large Compost", "Large Compost", "Large Compost", "Large Compost", "Plank", "Plank", "Plank"}, "Large Compost Plot", 1, "Iron Workshop");
	Recipe({"Mud Wall", "Mud Wall", "Large Leaves"}, "Mud Hut", 1, "Iron Workshop");
	Recipe({"Mud Wall", "Mud Wall", "Mud Wall", "Mud Wall", "Large Leaves", "Large Leaves"}, "Mud Longhouse", 1, "Iron Workshop");
	Recipe({"Mud Wall", "Mud Wall", "Large Leaves"}, "Mud Well", 1, "Iron Workshop");
	Recipe({"Wall", "Plank", "Plank"}, "Private Door", 1, "Iron Workshop");
	Recipe({"Sandstone Wall", "Sandstone Wall"}, "Sandstone Hut", 1, "Iron Workshop");
	Recipe({"Sandstone Wall", "Sandstone Wall"}, "Sandstone Well", 1, "Iron Workshop");
	Recipe({"Plank", "Plank", "Plank", "Plank"}, "Shelf", 1, "Iron Workshop");
	Recipe({"Small Compost", "Small Compost", "Small Compost", "Small Compost", "Plank", "Plank", "Plank"}, "Small Compost Plot", 1, "Iron Workshop");
	Recipe({"Wall", "Plank", "Plank", "Medium Handle", "Refined Iron"}, "Spear Wall", 1, "Iron Workshop");
	Recipe({"Stone Wall", "Stone Wall", "Thatching"}, "Stone Hut", 1, "Iron Workshop");
	Recipe({"Stone Wall", "Stone Wall", "Stone Wall", "Stone Wall", "Thatching", "Thatching"}, "Stone Longhouse", 1, "Iron Workshop");
	Recipe({"Stone Wall", "Window", "Charcoal", "Oil"}, "Stove", 1, "Iron Workshop");
	Recipe({"Stone Wall", "Stone Wall", "Thatching"}, "Well", 1, "Iron Workshop");
	Recipe({"Boulder", "Refined Iron", "Oil"}, "Oil Lightpost", 2, "Iron Workshop");
	Recipe({"Small Bush Stump", "Small Bush Stump", "Small Tree Stump"}, "Chair", 1, "Iron Workshop");

	--STEEL WORKSHOP
	Recipe({"Wall", "Wall", "Wall", "Small Tree Stump", "Small Tree Stump", "Plank", "Plank"}, "Harbor", 1, "Steel Workshop", "Unlocks advanced shipbuilding options");
	Recipe({"Small Bush Stump", "Glass", "Refined Steel"}, "Mixing Flask", 1, "Steel Workshop", "Unlocks a few potionmaking options");
	Recipe({"Stone Wall", "Stone Wall", "Plank", "Stainless Steel", "Thatching"}, "Stainless Workshop", 1, "Steel Workshop", "Unlocks all top-tier building options");
	--crafting stations above	
--	Recipe({"Wall", "Wall", "Plank", "Large Leaves", "Thatching"}, "Hen House", 1, "Steel Workshop");
	Recipe({"Stone Wall", "Stone Wall", "Boulder", "Boulder"}, "Hollow Medieval Tower", 1, "Steel Workshop");
	Recipe({"Stone Wall", "Stone Wall", "Stone Slab"}, "Medieval Corner Base", 1, "Steel Workshop");	
	Recipe({"Stone Wall", "Stone Wall", "Stone Wall", "Wall"}, "Medieval Gate", 1, "Steel Workshop");
	Recipe({"Stone Wall", "Stone Wall"}, "Medieval Half-Wall", 1, "Steel Workshop");
	Recipe({"Stone Wall", "Stone Wall", "Stone Wall", "Plank", "Plank", "Thatching"}, "Medieval House", 1, "Steel Workshop");
	Recipe({"Stone Wall", "Stone Wall", "Stone Slab"}, "Medieval Support Base", 1, "Steel Workshop");
	Recipe({"Stone Wall", "Stone Wall", "Stone Wall"}, "Medieval Tower", 1, "Steel Workshop");
	Recipe({"Stone Wall", "Stone Wall", "Stone Wall"}, "Medieval Wall", 1, "Steel Workshop");
	Recipe({"Small Tree Stump", "Small Tree Stump", "Small Stone", "Rope"}, "Quarry", 1, "Steel Workshop");
	Recipe({"Stone Wall", "Stone Wall", "Stone Wall", "Window", "Plank", "Plank", "Thatching"}, "Shop", 1, "Steel Workshop");
	Recipe({"Small Bush Stump", "Small Bush Stump", "Small Tree Stump", "Fabric", "Refined Gold"}, "Throne", 1, "Steel Workshop");
	Recipe({"Sandstone Wall", "Sandstone Wall", "Sandstone Brick", "Sandstone Brick"}, "Hollow Sandstone Tower", 1, "Steel Workshop");
	Recipe({"Sandstone Wall", "Sandstone Wall", "Sandstone Brick"}, "Sandstone Corner Base", 1, "Steel Workshop");	
	Recipe({"Sandstone Wall", "Sandstone Wall", "Sandstone Wall", "Wall"}, "Sandstone Gate", 1, "Steel Workshop");
	Recipe({"Sandstone Wall", "Sandstone Wall"}, "Sandstone Half-Wall", 1, "Steel Workshop");
	Recipe({"Sandstone Wall", "Sandstone Wall", "Sandstone Brick"}, "Sandstone Support Base", 1, "Steel Workshop");
	Recipe({"Sandstone Wall", "Sandstone Wall", "Sandstone Wall"}, "Sandstone Castle Tower", 1, "Steel Workshop");
	Recipe({"Sandstone Wall", "Sandstone Wall", "Sandstone Wall"}, "Sandstone Castle Wall", 1, "Steel Workshop");
	Recipe({"Small Tree Stump", "Small Tree Stump", "Sandstone", "Rope"}, "Sandstone Quarry", 1, "Steel Workshop");

	--STAINLESS WORKSHOP
	Recipe({"Stone Wall", "Stone Wall", "Stone Wall", "Stainless Steel", "Stainless Steel", "Thatching"}, "Smeltery", 1, "Stainless Workshop", "Unlocks advanced metalworking options");
	Recipe({"Stainless Steel", "Moss", "Moss"}, "Stainless Compost Bin", 1, "Stainless Workshop", "Unlocks top-tier farming options");
	--crafting stations above		
	Recipe({"Stone Slab", "Boulder", "Plank", "Plank"}, "Custom House Base", 1, "Stainless Workshop");
	Recipe({"Stone Slab", "Plank", "Plank"}, "Custom Stair Hole Base", 1, "Stainless Workshop");
	Recipe({"Plank", "Plank"}, "Custom Floorless Base", 1, "Stainless Workshop");
	Recipe({"Stone Slab", "Plank", "Plank", "Thatching"}, "Custom Roof", 1, "Stainless Workshop");
	Recipe({"Plank", "Thatching"}, "Custom Hole Roof", 1, "Stainless Workshop");
	Recipe({"Boulder", "Small Stone", "Plank"}, "Custom Stairs (Left)", 1, "Stainless Workshop");
	Recipe({"Boulder", "Small Stone", "Plank"}, "Custom Stairs (Right)", 1, "Stainless Workshop");
	Recipe({"Stone Wall"}, "Custom Wall", 1, "Stainless Workshop");
	Recipe({"Stone Wall"}, "Custom Window", 1, "Stainless Workshop");
	Recipe({"Stone Wall"}, "Custom Doorway", 1, "Stainless Workshop");
	Recipe({"Stone Wall", "Plank", "Plank"}, "Custom Private Doorway", 1, "Stainless Workshop");
	Recipe({"Boulder"}, "Custom Thin Wall", 1, "Stainless Workshop");
	Recipe({"Boulder", "Small Stone", "Small Stone"}, "Custom Railing", 1, "Stainless Workshop");
	Recipe({"Stone Wall", "Window"}, "Custom Glass Window", 1, "Stainless Workshop");
	Recipe({"Boulder", "Oil", "Window"}, "Custom Lightpost", 1, "Stainless Workshop");
	Recipe({"Stone Wall", "Stone Wall", "Stone Wall", "Charcoal", "Oil", "Thatching"}, "Bakery", 1, "Stainless Workshop");
	Recipe({"Stone Wall", "Stone Wall", "Stone Wall", "Stone Wall", "Stone Slab", "Oil"}, "Lighthouse", 1, "Stainless Workshop");
	Recipe({"Sandstone Wall", "Sandstone Wall", "Sandstone Wall", "Sandstone Wall", "Small Tree Stump", "Small Tree Stump"}, "Sandstone Hall", 1, "Stainless Workshop");
	Recipe({"Stone Wall", "Stone Wall", "Stone Wall", "Stone Slab", "Small Tree Stump", "Small Tree Stump", "Thatching", "Thatching"}, "Stone Hall", 1, "Stainless Workshop");
	Recipe({"Fertile Small Compost", "Fertile Small Compost", "Fertile Small Compost", "Fertile Small Compost", "Plank", "Plank", "Plank"}, "Fertile Small Compost Plot", 1, "Stainless Workshop");
	Recipe({"Fertile Large Compost", "Fertile Large Compost", "Fertile Large Compost", "Fertile Large Compost", "Plank", "Plank", "Plank"}, "Fertile Large Compost Plot", 1, "Stainless Workshop");	Recipe({"Sandstone Wall", "Sandstone Brick", "Plank", "Plank"}, "Custom House Base", 1, "Stainless Workshop");
	Recipe({"Sandstone Brick", "Plank", "Plank"}, "Custom Stair Hole Base", 1, "Stainless Workshop");
	Recipe({"Plank", "Plank"}, "Custom Floorless Base", 1, "Stainless Workshop");
	Recipe({"Sandstone Brick", "Sandstone Brick", "Plank", "Plank"}, "Custom Sandstone House Base", 1, "Stainless Workshop");
	Recipe({"Sandstone Brick", "Plank", "Plank"}, "Custom Sandstone Stair Hole Base", 1, "Stainless Workshop");
	Recipe({"Plank", "Plank"}, "Custom Sandstone Floorless Base", 1, "Stainless Workshop");
	Recipe({"Sandstone Brick", "Plank", "Plank", "Sandstone Wall"}, "Custom Sandstone Roof", 1, "Stainless Workshop");
	Recipe({"Plank", "Sandstone Wall"}, "Custom Sandstone Hole Roof", 1, "Stainless Workshop");
	Recipe({"Sandstone Brick", "Sandstone", "Plank"}, "Custom Sandstone Stairs (Left)", 1, "Stainless Workshop");
	Recipe({"Sandstone Brick", "Sandstone", "Plank"}, "Custom Sandstone Stairs (Right)", 1, "Stainless Workshop");
	Recipe({"Sandstone Wall"}, "Custom Sandstone Wall", 1, "Stainless Workshop");
	Recipe({"Sandstone Wall"}, "Custom Sandstone Window", 1, "Stainless Workshop");
	Recipe({"Sandstone Wall"}, "Custom Sandstone Doorway", 1, "Stainless Workshop");
	Recipe({"Sandstone Wall", "Plank", "Plank"}, "Custom Sandstone Private Doorway", 1, "Stainless Workshop");
	Recipe({"Sandstone Brick"}, "Custom Sandstone Thin Wall", 1, "Stainless Workshop");
	Recipe({"Sandstone Brick", "Sandstone", "Sandstone"}, "Custom Sandstone Railing", 1, "Stainless Workshop");
	Recipe({"Sandstone Wall", "Window"}, "Custom Sandstone Glass Window", 1, "Stainless Workshop");
	Recipe({"Sandstone Brick", "Oil", "Window"}, "Custom Sandstone Lightpost", 1, "Stainless Workshop");

-- "TRANSPORTATION"

	--N/A
	Recipe({"Hull"}, "Raft", 1);
	
	--DOCK
	Recipe({"Hull", "Small Tree Stump", "Sail"}, "Sailboat", 1, "Dock");
	Recipe({"Large Hull", "Large Tree Stump", "Sail", "Sail"}, "Large Sailboat", 1, "Dock");

	--IRON WORKSHOP
	Recipe({"Plank", "Plank", "Plank", "Wood Seat"}, "Cart", 1, "Iron Workshop");

	--STEEL WORKSHOP
	Recipe({"Plank", "Plank", "Plank", "Small Tree Stump", "Wood Seat"}, "Catapult", 1, "Steel Workshop");
	
	--HARBOR
	Recipe({"Hull", "Hull", "Plank", "Small Tree Stump", "Sail"}, "Catamaran", 1, "Harbor");
	Recipe({"Large Hull", "Large Hull", "Large Tree Stump", "Large Tree Stump", "Large Tree Stump", "Sail", "Sail"}, "Merchant Frigate", 1, "Harbor");
	Recipe({"Large Hull", "Hull", "Small Tree Stump", "Small Tree Stump", "Small Tree Stump", "Sail", "Sail", "Sail"}, "War Sloop", 1, "Harbor");
	

-- "ITEMS"

	--N/A
	Recipe({"Small Bush Stump"}, "Wood Seat");
	Recipe({"Small Stone"}, "Stone Seat");
	Recipe({"Sandstone"}, "Sandstone Seat");
	Recipe({"Pile of Mud"}, "Mud Seat");
	Recipe({"Small Stick", "Corn"}, "Corn on a Stick");
	Recipe({"Dough"}, "Uncooked Bread");
	Recipe({"Small Tree Stump"}, "Handle");
	Recipe({"Small Tree Stump"}, "Medium Handle");
	Recipe({"Small Tree Stump"}, "Large Handle");
	Recipe({"Small Tree Stump", "Small Tree Stump"}, "Wall");
	Recipe({"Small Tree Stump", "Small Tree Stump"}, "Hull");
	Recipe({"Small Stone", "Small Stone"}, "Boulder");
	Recipe({"Small Stone", "Small Stone"}, "Cut Stone");
	Recipe({"Wheat", "Wheat", "Wheat", "Wheat"}, "Wheat Bundle");
	Recipe({"Wheat", "Wheat", "Wheat", "Wheat"}, "Thatching");
	Recipe({"Large Handle"}, "Medium Handle");
	Recipe({"Large Handle"}, "Handle");
	Recipe({"Small Bush Stump"}, "Small Stick");
	Recipe({"Wheat"}, "Wheat Seed");
	Recipe({"Wheat", "Wheat"}, "Nest");
	Recipe({"Carrot"}, "Carrot Seed");
--	Recipe({"Pumpkin"}, "Pumpkin Seed", 3);
	Recipe({"Small Stick", "Small Stick"}, "Handle");
	Recipe({"Rockma Hide"}, "Boulder");
	Recipe({"Medium Handle"}, "Handle");
	Recipe({"Flax", "Flax"}, "String");
	Recipe({"Small Stick", "Small Stick", "Small Stick"}, "Medium Handle");
	Recipe({"Small Stick", "Small Stick", "Small Stick", "Small Stick"}, "Large Handle");
	Recipe({"Small Bush Stump", "Small Bush Stump"}, "Handle");
	Recipe({"Small Bush Stump", "Small Bush Stump"}, "Medium Handle");
	Recipe({"Small Bush Stump", "Small Bush Stump"}, "Large Handle");
	Recipe({"Pile of Sand", "Pile of Sand", "Pile of Sand"}, "Sandstone"); 
	Recipe({"Sandstone", "Sandstone"}, "Sandstone Brick");
	Recipe({"Sandstone Brick", "Sandstone Brick"}, "Sandstone Wall");
	Recipe({"String", "String"}, "Rope");
	Recipe({"Rope"}, "String");
	Recipe({"Stalk"}, "String");
	Recipe({"Stalk", "Stalk"}, "Rope");
	Recipe({"Boulder", "Small Stone"}, "Stone Slab");
	Recipe({"Boulder", "Boulder"}, "Stone Wall");	
	
	Recipe({"Plank", "Plank"}, "Wall");
	Recipe({"Yew Stump", "Yew Stump"}, "Wall");
	Recipe({"Small Leaves", "Small Leaves"}, "Hemp");
	Recipe({"Large Leaves"}, "Hemp");
	Recipe({"Hemp"}, "Rope");
	Recipe({"Large Pile of Mud", "Large Pile of Mud"}, "Mud Wall");
	Recipe({"Pile of Mud", "Pile of Mud"}, "Large Pile of Mud");
	Recipe({"Boulder"}, "Small Stone");
	
	-- Dyes!
	Recipe({"Prickly Pear"}, "Red Dye");
	Recipe({"Carrot"}, "Orange Dye");
	Recipe({"Berry"}, "Purple Dye");
	Recipe({"Flax Flower"}, "Blue Dye");
	Recipe({"Crude Oil"}, "Black Dye");
	Recipe({"Sulphur"}, "Yellow Dye");
	Recipe({"Milk"}, "White Dye");
	Recipe({"Red Dye", "White Dye"}, "Pink Dye", 2),
	Recipe({"Prickly Pear Leaf"}, "Green Dye"),
	Recipe({"Large Leaves"}, "Green Dye", 4),
	Recipe({"Small Leaves"}, "Green Dye", 2),
	Recipe({"Green Dye", "Blue Dye"}, "Teal Dye", 2),
	Recipe({"Green Dye", "Black Dye"}, "Dark Green Dye", 2),
	Recipe({"Red Dye", "Black Dye"}, "Dark Red Dye", 2),
	Recipe({"Blue Dye", "Black Dye"}, "Dark Blue Dye", 2),
	Recipe({"Green Dye", "White Dye"}, "Light Green Dye", 2),
	Recipe({"Blue Dye", "White Dye"}, "Light Blue Dye", 2),
	Recipe({"Black Dye", "White Dye"}, "Gray Dye", 2),
		
	--MIXING FLASK
	Recipe({"Glass Cup", "Mushroom", "Mushroom" }, "Poison", 1, "Mixing Flask");
	Recipe({"Glass Cup", "Herb", "Herb", "Flax Flower" }, "Herbal Remedy", 1, "Mixing Flask");
	
	--LUMBERMILL
	Recipe({"Small Tree Stump"}, "Plank", 2, "Lumbermill");
	Recipe({"Large Tree Stump"}, "Plank", 8, "Lumbermill");
	Recipe({"Small Bush Stump"}, "Woodchips", 1, "Lumbermill");
	
	--MILL
	Recipe({"Wheat Bundle"}, "Flour", 1, "Mill");
	Recipe({"Corn"}, "Corn Meal", 1, "Mill");
	
	--COIN PRESS
	Recipe({"Refined Gold"}, "Gold Coin", 2, "Coin Press");
	
	--PRIMITIVE DESIGN TABLE
	Recipe({"Large Tree Stump"}, "Wall", 2, "Primitive Design Table");
	Recipe({"Small Stick", "Cut Stone"}, "Arrow", 1, "Primitive Design Table");
	Recipe({"Glass"}, "Glass Cup", 1, "Primitive Design Table");
	Recipe({"Glass", "Glass"}, "Window", 1, "Primitive Design Table");
	Recipe({"Wet Clay"}, "Clay Bowl", 1, "Primitive Design Table");
--	Recipe({"Oil", "Wet Clay"}, "Mixture", 1, "Primitive Design Table");
	Recipe({"Flax", "Flax", "Flax", "String"}, "Fabric", 1, "Primitive Design Table");
	Recipe({"Fabric", "Fabric"}, "Carpet", 1, "Primitive Design Table");
	Recipe({"Hull", "Hull"}, "Large Hull", 1, "Primitive Design Table");
	Recipe({"Hemp", "Hemp"}, "Sail", 1, "Primitive Design Table");
	Recipe({"Bento Leather"}, "Primitive Armor", 1, "Primitive Design Table", "-33% damage taken. (-0 speed)");
	Recipe({"Fabric", "Fabric", "Fabric"}, "Primitive Armor", 1, "Primitive Design Table", "-33% damage taken. (-0 speed)");
	Recipe({"Primitive Armor", "Rockma Hide"}, "Rockma Hide Armor", 1, "Primitive Design Table", "-42.5% melee damage, -33% range damage. (-0.5 speed)");
	Recipe({"Coal", "Coal"}, "Charcoal", 1, "Primitive Design Table");
	Recipe({"Bento Hide"}, "Bento Leather", 1, "Primitive Design Table");
		
	--DOCK
	Recipe({"Hull", "Hull"}, "Large Hull", 1, "Dock");
	Recipe({"Hemp", "Hemp"}, "Sail", 1, "Dock");

	--QUALITY DESIGN TABLE
--	Recipe({"Small Stick", "Gunpowder"}, "Firework", 5, "Quality Design Table");
	Recipe({"Bento Leather", "Lynx Fur", "Fabric"}, "Quiver", 1, "Quality Design Table", "Reload all arrow/bolt weapons twice as fast.");
	Recipe({"Primitive Armor", "Fabric", "Moss", "String"}, "Woven Vest", 1, "Quality Design Table", "-40% damage taken, +20% projectile damage. (-0 Speed)");
	Recipe({"Feather", "Small Stick", "Refined Iron"}, "Iron Arrow", 1, "Quality Design Table");
	Recipe({"Feather", "Small Stick", "Refined Steel"}, "Steel Arrow", 1, "Quality Design Table");
	Recipe({"Rope", "Charcoal"}, "Fuse", 1, "Quality Design Table");
	Recipe({"Plank", "Plank", "Gunpowder", "Gunpowder", "Fuse"}, "Bomb", 1, "Quality Design Table");
	Recipe({"Teraphyx Horn", "Teraphyx Horn", "Teraphyx Horn", "Teraphyx Horn"}, "Teraphyx Dust", 1, "Quality Design Table");
	Recipe({"Stainless Steel", "Stainless Steel", "Stainless Steel", "Refined Gold", "Charcoal", "Teraphyx Dust"}, "Raw Bluesteel", 2, "Quality Design Table");
	Recipe({"Yew Stump"}, "Yew Handle", 1, "Quality Design Table");
	Recipe({"Refined Iron", "Coal"}, "Steel Mix", 1, "Quality Design Table");
	Recipe({"Refined Steel", "Refined Chromium", "Refined Chromium"}, "Stainless Mix", 1, "Quality Design Table");
	Recipe({"Sulphur", "Charcoal", "Charcoal"}, "Gunpowder", 1, "Quality Design Table");
	
	--CULINARY TABLE
	Recipe({"Glass Cup", "Berry", "Berry"}, "Berry Juice", 1, "Culinary Table");	
	Recipe({"Glass Cup", "Prickly Pear"}, "Prickly Pear Juice", 1, "Culinary Table");
	Recipe({"Glass Cup", "Snow"}, "Cup of Snow", 1, "Culinary Table");
	Recipe({"Glass Cup", "Milk"}, "Glass of Milk", 1, "Culinary Table"),
	Recipe({"Glass Cup", "Apple", "Apple"}, "Apple Juice", 1, "Culinary Table");
	Recipe({"Raw Bento Venison", "Herb", "Herb"}, "Raw Spiced Bento Venison", 1, "Culinary Table");
	Recipe({"Clay Bowl", "Wheat Seed", "Wheat Seed"}, "Uncooked Seed Mush", 1, "Culinary Table");
	Recipe({"Dough", "Corn Meal"}, "Uncooked Corn Bread", 1, "Culinary Table");
--	Recipe({"Dough", "Pumpkin"}, "Unbaked Pumpkin Pie", 1, "Culinary Table");
	Recipe({"Raw Chicken", "Corn Meal"}, "Raw Breaded Chicken", 1, "Culinary Table");
	Recipe({"Raw Mackerel", "Raw Sardine", "Raw Sardine", "Herb", "Onion"}, "Fish Roll", 3, "Culinary Table");
	
	--WOOD COMPOST BIN
	Recipe({"Small Leaves"}, "Small Compost", 1, "Wood Compost Bin");
	
	--IRON COMPOST BIN
	Recipe({"Large Leaves"}, "Large Compost", 1, "Iron Compost Bin");
	
	--STAINLESS COMPOST BIN
	Recipe({"Moss", "Moss"}, "Moss Compost", 1, "Stainless Compost Bin");
	Recipe({"Small Compost", "Woodchips"}, "Fertile Small Compost", 1, "Stainless Compost Bin");
	Recipe({"Large Compost", "Woodchips"}, "Fertile Large Compost", 1, "Stainless Compost Bin");	
	
	--FORGE
	Recipe({"Small Stick", "Refined Steel"}, "Bolt", 1, "Forge");
	Recipe({"Refined Iron"}, "Iron Gear", 1, "Forge");
	Recipe({"Primitive Armor", "Refined Iron", "Refined Iron"}, "Iron Chainmail", 1, "Forge", "-48% melee damage, -53% range damage. (-0.5 speed)");	
	Recipe({"Rockma Hide Armor", "Refined Iron", "Refined Iron"}, "Iron Platemail", 1, "Forge", "-54.5% melee damage, -45% range damage. (-1 speed)");
	Recipe({"Primitive Armor", "Refined Steel", "Refined Steel"}, "Steel Chainmail", 1, "Forge", "-58% melee damage, -62.5% range damage. (-1.5 speed)");
	Recipe({"Rockma Hide Armor", "Refined Steel", "Refined Steel"}, "Steel Platemail", 1, "Forge", "-62.5% melee damage, -57% range damage. (-2 speed)");
	
	--SMELTERY
	Recipe({"Primitive Armor", "Refined Mithril", "Refined Mithril", "Refined Gold"}, "Mithril Chainmail", 1, "Smeltery", "-70% melee damage, -75% range damage. (-0.5 speed)");
	Recipe({"Rockma Hide Armor", "Pure Bluesteel", "Pure Bluesteel", "Refined Chromium"}, "Bluesteel Platemail", 1, "Smeltery", "-76.5% melee damage, -68.5% range damage. (-1 speed)");
	
	--BAKERY
	Recipe({"Dough", "Berry", "Berry"}, "Unbaked Berry Pie", 1, "Bakery");
	Recipe({"Dough", "Apple", "Apple"}, "Unbaked Apple Pie", 1, "Bakery");
--	Recipe({"Dough", "Peppermint Stick", "Peppermint Stick"}, "Unbaked Peppermint Cupcake", 3, "Bakery");
	Recipe({"Dough", "Carrot", "Carrot"}, "Unbaked Carrot Cake", 1, "Bakery");

	
-- "TOOLS"
	
	--N/A
	Recipe({"Handle"}, "Club");
	Recipe({"Large Handle"}, "Battle Club");	
	Recipe({"Hemp"}, "Canteen");
	Recipe({"Handle", "String"}, "Crude Rod");
	Recipe({"Small Stick", "Small Stick", "String"}, "Slingshot");
	Recipe({"Handle", "Hemp"}, "Crude Torch");
	Recipe({"Handle", "Rope"}, "Firemaking Bow", 1, nil, "20% chance to start fires");
		
	--PRIMITIVE DESIGN TABLE 
	Recipe({"Small Bush Stump", "Rope"}, "Wood Bucket", 1, "Primitive Design Table");
	Recipe({"Small Bush Stump", "Rope"}, "Crude Milking Pail", 1, "Primitive Design Table");
	Recipe({"Wet Clay", "Wet Clay"}, "Clay Bucket", 1, "Primitive Design Table");
--	Recipe({"Handle", "Fabric"}, "Paintbrush", 1, "Primitive Design Table");	
	Recipe({"Cut Stone", "Cut Stone"}, "Flint", 1, "Primitive Design Table");
	Recipe({"String", "String", "String"}, "Net", 1, "Primitive Design Table");
	Recipe({"Handle", "Hemp", "Oil"}, "Oil Torch", 1, "Primitive Design Table");
	Recipe({"Handle", "String", "String"}, "Shortbow", 1, "Primitive Design Table");
	Recipe({"Handle", "Cut Stone"}, "Stone Axe", 1, "Primitive Design Table", "40% chance to chop Small Trees");
	Recipe({"Handle", "Cut Stone"}, "Stone Pickaxe", 1, "Primitive Design Table", "40% chance to mine only Iron");
	Recipe({"Cut Stone", "String"}, "Stone Knife", 1, "Primitive Design Table");	
	Recipe({"Medium Handle", "Cut Stone"}, "Stone Spear", 1, "Primitive Design Table");
	Recipe({"Medium Handle", "Cut Stone"}, "Stone Javelin", 1, "Primitive Design Table");
	Recipe({"Small Bush Stump", "Hemp", "Rope"}, "Crude Oil Filter", 1, "Primitive Design Table");

	
	--QUALITY DESIGN TABLE 
	Recipe({"Wet Clay", "Hemp", "Rope"}, "Oil Filter", 1, "Quality Design Table");
	Recipe({"Refined Iron", "Oil", "Glass", "Rope"}, "Lantern", 1, "Quality Design Table");
	Recipe({"Medium Handle", "String"}, "Long Rod", 1, "Quality Design Table");
	Recipe({"Medium Handle", "String", "String"}, "Long Bow", 1, "Quality Design Table");
	Recipe({"Stainless Steel", "String"}, "Stainless Rod", 1, "Quality Design Table");
	
	--FORGE 
	Recipe({"Handle", "Refined Iron"}, "Iron Axe", 1, "Forge", "60% chance to chop any wood but Yew");
	Recipe({"Handle", "Refined Iron"}, "Iron Pickaxe", 1, "Forge", "60% chance to mine Iron, Coal, and Sulphur");
	Recipe({"Handle", "Refined Steel"}, "Steel Axe", 1, "Forge", "80% chance to chop any type of wood");
	Recipe({"Handle", "Refined Steel"}, "Steel Pickaxe", 1, "Forge", "80% chance to mine any type of ore");
	Recipe({"Refined Iron", "Rope"}, "Iron Bucket", 1, "Forge");
	Recipe({"Refined Iron", "Rope"}, "Milking Pail", 1, "Forge");
	Recipe({"Refined Steel", "Rope"}, "Steel Bucket", 1, "Forge");
	Recipe({"Cut Stone", "Refined Steel"}, "Flint and Steel", 1, "Forge", "65% chance to start fires");
	Recipe({"Small Stick", "Refined Iron"}, "Iron Sickle", 1, "Forge");
	Recipe({"Small Stick", "Refined Steel"}, "Steel Sickle", 1, "Forge");
	Recipe({"Refined Iron", "String"}, "Iron Knife", 1, "Forge");
	Recipe({"Refined Steel", "String"}, "Steel Knife", 1, "Forge");	
	Recipe({"Refined Iron", "Refined Iron"}, "Iron Sword", 1, "Forge");
	Recipe({"Refined Steel", "Refined Steel"}, "Steel Sword", 1, "Forge");
	Recipe({"Medium Handle", "Refined Iron"}, "Iron Spear", 1, "Forge");
	Recipe({"Medium Handle", "Refined Steel"}, "Steel Spear", 1, "Forge");
	Recipe({"Medium Handle", "Refined Iron"}, "Iron Javelin", 1, "Forge");
	Recipe({"Medium Handle", "Refined Steel"}, "Steel Javelin", 1, "Forge");
	Recipe({"Medium Handle", "Refined Steel", "String", "String"}, "Crossbow", 1, "Forge");
	Recipe({"Refined Iron", "Refined Iron", "Refined Iron"}, "Iron Cheese Bin", 1, "Forge");
--	Recipe({"Refined Iron", "Refined Iron"}, "Ladle", 1, "Forge");
			
	--SMELTERY
	Recipe({"Handle", "Refined Mithril"}, "Mithril Axe", 1, "Smeltery", "100% chance to chop any type of wood");
	Recipe({"Handle", "Refined Mithril"}, "Mithril Pickaxe", 1, "Smeltery", "100% chance to mine any type of ore");
	Recipe({"Handle", "Pure Bluesteel"}, "Bluesteel Axe", 1, "Smeltery", "100% chance to chop any type of wood");
	Recipe({"Handle", "Pure Bluesteel"}, "Bluesteel Pickaxe", 1, "Smeltery", "100% chance to mine any type of ore");	
	Recipe({"Refined Gold", "Refined Gold"}, "Gold Bucket", 1, "Smeltery");
	Recipe({"Pure Bluesteel", "Charcoal"}, "Bluesteel Igniter", 1, "Smeltery", "90% chance to start fires");
	Recipe({"Refined Mithril", "Charcoal"}, "Mithril Strikekit", 1, "Smeltery", "80% chance to start fires");
	Recipe({"Small Stick", "Refined Mithril"}, "Mithril Sickle", 1, "Smeltery");
	Recipe({"Small Stick", "Pure Bluesteel"}, "Bluesteel Sickle", 1, "Smeltery");
	Recipe({"Refined Mithril", "String"}, "Mithril Knife", 1, "Smeltery");
	Recipe({"Pure Bluesteel", "String"}, "Bluesteel Knife", 1, "Smeltery");
	Recipe({"Refined Mithril", "Refined Mithril", "Refined Gold"}, "Mithril Sword", 1, "Smeltery");
	Recipe({"Pure Bluesteel", "Pure Bluesteel", "Refined Chromium"}, "Bluesteel Sword", 1, "Smeltery");
	Recipe({"Yew Handle", "Refined Mithril"}, "Mithril Spear", 1, "Smeltery");
	Recipe({"Yew Handle", "Pure Bluesteel"}, "Bluesteel Spear", 1, "Smeltery");
	Recipe({"Yew Handle", "Refined Mithril"}, "Mithril Javelin", 1, "Smeltery");
	Recipe({"Yew Handle", "Pure Bluesteel"}, "Bluesteel Javelin", 1, "Smeltery");
	Recipe({"Yew Handle", "Refined Mithril", "String", "String"}, "Yewbeam Bow", 1, "Smeltery");
	Recipe({"Yew Handle", "Pure Bluesteel", "String", "String"}, "Yew Crossbow", 1, "Smeltery");

	
}