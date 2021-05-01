--[[
Breaking Bugs:
	Medieval Gates tear apart islands when used.
		Might be fixable with welds, may just need to resort to shrinking the part instead of moving it (though this breaks weld gizmos).
		Prevent gate from moving if it's connected to an anchored part?
	Working on this, tried replacing direct CFrame manipulation with weld. This broke things in new ways (related to lumbermill bug). Investigate why parts are being placed in the void.

Minor Issues:
	Many buildings are rotated wrong.
		I believe this is caused by the BOUNDINGBOX just being oriented funny - should be an easy fix.
		
	A **lot** of resources are missing welds.
		Basically everything on mainland isn't welded to it.
		Flax falls apart when kicked.
			All natural flax, maybe planted flax too?
		Snowpeak's apples fall down :(
			Paradise apples are fine.
		May be fixable by just running MakeJoints() on literally everything in Resources.
			While I'm at it, could be worth checking against prototypes (for stuff like the T1 choppable bug).

	Items placed in the same location aren't placed on top of each other.
		Parts need to be placed using safe-place.
		Dunno how to go about this - roblox seem to have changed this behaviour.
	
	Some crops still use old models, despite new models existing.
		Onions at least.
		Various "shoots" can be removed.
			If pumpkin shoots exist, they should be flammable/edible.
	
	Bombs don't destroy buildings.
		This is more of a feature than a bug (would need a new system to detect and handle this), but it's expected behaviour.
		Maybe bombs should un-fireproof and ignite fireproofed parts in range? Would be possible.
			For bonus points, this gives semi-free implementation of chain bomb explosions.
	
	Animals lag the game.
		The hacky fix is to disable them in studio so my computer melts less.
		The less hacky fix is to have them sleep when no player is nearby, so the roblox servers melt less.
		The enlightened ultimate fix is to just rewrite the animal AI so it doesn't melt things when running.
	
	There are a few exploits I should patch.
		Gathering, using tools and consuming can be done at any distance.
		You can bypass tool cooldowns by just spamming the remote.
		Boats have no sanity checks for movement.
		There seems to be a gift opening exploit.

Investigations:
	Dragging might not handle welds correctly with low ping.
		It sounds like the weld isn't being broken in time. Hm.
	
	The game relies on a variety of assets referenced in the code - many are private to the group.
		Drag is the most obvious and important one.
		Are bomb sounds ok?
		I'll need to find and replace these with public decals.
	
	The forked chat script errors sometimes.
		I think it's harmless, but someone in a live server got heavy lag spikes when they triggered it.
		I've only been able to trigger it by simultaneously giving myself a tool and an item.
			This does not result in a lag spike.
		The other person got a lag spike after every message. I don't know why or how.
	
	Sometimes buildings placed directly next to each other will "overlap", causing the new building to be placed above the old one
	(and then immediately fall down).
		The preview doesn't have this issue. Investigate.
		Likely caused by floating point precision - might need to replace MoveTo with SetCFrame, and run my own (relaxed) collision checks.
		
	Some islands seem to be offset from the stud grid.
		Is this fixable, or is it intrinsic to floating point problems?
		If not fixable, will need relaxed collision checks.
	
	I think VIP server settings are broken.
		In the main game apparantly a lot of the options don't work as intended.
		It errors whenever we start up, so at the very least that needs looking into.
	
	Crafting breaks after jumping/flinging into the void.
		Why does this happen?

	Load is used EVERYWHERE, but is supposedly deprecated in favour of Import.
		What's the difference?
		I should investigate, and possibly do a mass update to remove Load altogether if Import is better.
	
	Fire's scripts claim it has "massive performance issues".
		I've not seen any of these, but it's worth a look.

Cleaning:
	Some items are duplicated in Items and Constructables and the like.
		I've fixed the ones I know of, but no automated search yet.
		This can cause bugs - search and destroy.

	Bans only work in the Production Server (the actual 303 place).
		Datastore handling in general is poor throughout - I believe it's possible to overload the datastore
		system by just spam-changing hotkeys.
		This is harmless, but should probably be sorted out.

	Most of Lighting is useless/outdated and can probably be removed.
	
Features:
	Reimplement pumpkins.
		and pumpkin pie
	
	Warnings for low stats.

	Catacomb is in Lighting, named halo's.
		It only needs a few minor tweaks to be implemented into the game.
		Also needs to have all its resources run through the prototype processor thing.
	
	Iron on more islands.
	
	Filters for the crafting menu.
		Only show recipes available at accessible crafting stations (default on).
		Only show recipes that can be crafted (default off).
		Searching should respect filters, but if no results, "Results found with filters off ->"
	Searching for a station name should return all recipes in that station.
		And all recipes that it inherits from.
		Ensure the actual recipe for the station is listed first.
	Second button to craft 10.
	
	Gathering could use a lot of QoL upgrades.
		The client should have more authority when gathering - assume success and verify, rather than wait for verification.
		Small Items should gather instantly.
		Holding down click should repeatedly gather.
			Unless it's compost. Compost is the exception.
		The player should be free to continue moving when gathering small items.
			Slow proportional to size of item?
	
	When reloading a ranged weapon or firestarter, the player should be slowed.
		May need a walkspeed handler.
		
	Rejected action feedback.
		If a player attempts to use a tool on something it's not a high enough tier for, reject the action.
		Rejected actions have angry noises and a different colour highlight.
	
	Watchtowers.
		If a player in another tribe enters the range of a watchtower (determined by its tier),
		a chat message will be sent to players in the owner's tribe.
		Players can't trigger a tribe's watchtowers more than once per minute to prevent spam.
	A hood (~late classical tier) can be worn to drastically reduce the range you can be detected from,
		so stealth remains possible so long as you're actually developed and not just using it to flint someone's base.
	
	Mithril should respawn in a random location every time it's mined.
	
	Bombs should chain explode.
		Either find all connected bombs and calculate a simple epicentre.
		Or do something fancier to correctly handle the case of two piles of bombs with a line of powder between.
		They should make a cooler sound too.
		And be buildings.
		And be defusable / not directly lightable (sparks?).
		
	Quick village building tool for testing (spam place a bunch of buildings).
	
	"Bonfire" calculation - burning parts near each other group together for fire calculations.
		This will increase the range of a big pile of burning detritus (realistic).
		Also may improve performance, much fewer individual fire scripts.
			Can be used to increase fire's tickrate.
		Small parts are easier to light? Helps ensure buildings don't catch if they clip a bonfire radius.
		Ideally something deterministic regardless of where the fire starts.
	
	Fireworks! :D
		Dye fireworks to change their colour.
		Craft different types of firework to change their style.
	
	Building stacking in toolbar.
--]]