--[[
	v2.7.1 NB
		Added Fabric Armour.
		Fixed LoadLibrary calls. https://devforum.roblox.com/t/loadlibrary-is-going-to-be-removed-on-february-3rd/382516
		Implemented grub's fix for the item placement bug.
		Migrated all LinkedSource scripts into module scripts, so the game works unmodified when copied.
		Disabled Build Tools because they rely on an asset owned by the 303 Community Group.
	
	v2.7.2 NB
		Discovered the root cause of the item placement bug and fixed it properly.
			(well, fixing it PROPERLY would be to stop relying on deprecated functions, but eh)
		Fixed certain islands being gatherable.
		3/4 Bread is now edible.
	
	v2.7.3 NB
		Removed over 25,000 redundant (anchored to anchored) welds from workspace.
		Removed around 4,000 redundant World Block prototypes in Islands, replacing them with a top level one.
			This fixed the couple remaining islands that were still gatherable.
		Removed all 20,000ish of the old format ValueObject tags.
			The tiny handful still in use (RARITY, TYPE, NORESPAWN, and notionally Quarryable) were migrated.
		Identified and corrected around 500 cases where a prototype value was missing.
			This fixed the gatherable chromium bug, the gatherable boats bug, and a number more (mostly buildings that didn't burn).
		Converted all ObjectValue prototypes to StringValue prototypes to guard against the above issue in future.
		If the big numbers didn't make it clear, I've made some massive automated changes to the game's
			backend and it's entirely possible I broke something by accident.
		
		I am now an admin.
	
	v2.7.4 NB
		Experimental massive buff to saturation - it no longer looks like it's broken.
			Saturation is now 4x more effective at slowing hunger (providing a total halt at 25% saturation),
			and decreases 20x slower - 4x slower than hunger.
			Maxing your saturation wastes a lot of food, but effectively gives you ~470 total hunger.
			Most late-ish game food items (good fish, baked foods) are about 1.5x better as a result.
		Migrated armour's Speed ValueObject to the new system, fixing armour.
	
	v2.7.5 NB
		Removed all the manualwelds from buildings, fixing the lumbermill/mill bug.
	
	v2.7.6 NB
		Corrected an error in OceanService where it ignored the Y value for the ocean's origin. Didn't make the ocean deeper.
	
	v2.7.7 NB	
		Added a new class of tool called "Sabre" to test animations on tools.
			Very proof of concept, doesn't even play an animation.
			Only one tool uses it, !TestSabre, which is a battleclub except you can't craft it.
			This should probably be removed.
		Corrected a typo in the name of Burnt Out Blargium, which was a trip hazard for people trying to use it in their o303 forks.
		Corrected three Cave-Ins with missing prototypes, causing the rocks to be unminable (instead, they could only be foraged).
		Fixed a bug preventing Custom Sandstone Wall from being placed.
		Experimentally re-enabled the code responsible for buildings saving if you rejoin in 15 minutes.
			I don't know why it was disabled - there was presumably a bug but I can't find it.
			I can only test in a live server, so we'll see how this goes.
		Broke Medieval Gates while trying to fix the bug where they tear apart islands.
			Sandstone gate script is unchanged if I want to revert.
			Possible fixes include:
				Finding the correct weld and doing the weld manipulations that way.
				Giving up and opening/closing the gate in some other way.
					Growing/Shrinking may not play nicely with welds. Simplest solution is to make it transparent and nocollide.
		Added support for recipes with no ingredients - didn't add any new recipes though.
			
--]]