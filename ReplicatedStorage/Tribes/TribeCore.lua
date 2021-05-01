-- Core of the tribe system.
-- Contains shared code and logic.
local Teams = game:GetService("Teams")

local import = require(game:GetService("ReplicatedStorage"):WaitForChild("Import"))
local Data = import "~/Data/DataAccessor"

-- All the colors that tribes can use.
-- There are 18 colors in this table, which corresponds to the current maximum player count of 18.
-- This allows, at present, every player to have a tribe of their own should they so desire.
local TribeColors = { 
	BrickColor.new("Bright red"),
	BrickColor.new("Burgundy"),
	BrickColor.new("Br. yellowish orange"),
	BrickColor.new("CGA brown"),
	BrickColor.new("Daisy orange"),
	BrickColor.new("New Yeller"),
	BrickColor.new("Br. yellowish green"),
	BrickColor.new("Sand green"),
	BrickColor.new("Bright green"),
	BrickColor.new("Earth green"),
	BrickColor.new("Bright bluish green"),
	BrickColor.new("Teal"),
	BrickColor.new("Bright blue"),
	BrickColor.new("Lapis"),
	BrickColor.new("Bright violet"),
	BrickColor.new("Alder"),
	BrickColor.new("Pink"),
	BrickColor.new("Magenta"),
}

-- TribeCore uses a Tribe type.
-- This type is a table that encapsulates the state of a tribe *at that point in time*.
-- A Tribe is only valid immediately after retrieving it; after that, some aspects of it may change.
-- Tribes have the following members:
-- Name (string): the tribe's name.
-- Color (BrickColor): the tribe's color.
-- Team (Team): the Team object the tribe is associated with.
-- Owner (Player): the tribe's owner.
-- Members (array<Player>): all members of the tribe, including the owner.
-- Jobs (map<int, Variant<string, null>>): the tribe's job assignments, indexed by member user ID.
-- Ranks (map<int, TribeRank>): the tribe's rank assignments, indexed by member user ID.

-- Tribe jobs / ranks / the owner reference are stored in the Team object that represents the tribe.
-- Jobs are stored in the TribeJobs key, indexed by user ID. If null, TribeCore.DefaultJob should be displayed instead.
-- Ranks are stored in the TribeRanks key, indexed by user ID.
-- The owner is stored in the Owner key, and points directly to the player.

local TribeCore = {}
TribeCore.Colors = TribeColors

-- Networking references
TribeCore.Network = {
	-- RemoteFunction called to create a tribe.
	CreateTribe = import "~/Tribes/Network/CreateTribe";
	-- RemoteFunction called to send a player an invite.
	SendInvite = import "~/Tribes/Network/SendInvite";
	-- RemoteEvent for job changes
	-- Fired by the client to attempt to change a player's job
	-- Fired by the server to notify tribe members of a job change
	ChangeJob = import "~/Tribes/Network/ChangeJob";
	-- RemoteEvent for owner changes
	-- Fired by the client to attempt to change the tribe's owner
	-- Fired by the server to notify tribe members of an owner change
	ChangeOwner = import "~/Tribes/Network/ChangeOwner";
	-- RemoteEvent for rank changes
	-- Fired by the client to attempt to change a player's rank
	-- Fired by the server to notify tribe members of a rank change
	-- Also fired by the server when a tribe's owner is changed
	ChangeRank = import "~/Tribes/Network/ChangeRank";
	-- RemoteEvent for handling a tribe invite
	-- Fired by the client to accept a tribe invite
	-- Fired by the server to notify a client that they have received an invite
	HandleInvite = import "~/Tribes/Network/HandleInvite";
	-- RemoteEvent for members joining a tribe
	-- Fired by the server to notify a player that they joined a tribe
	JoinTribe = import "~/Tribes/Network/JoinTribe";
	-- RemoteEvent fired in conjunction with JoinTribe
	-- Fired by the server to notify existing tribe members that a player joined a tribe.
	JoinedTribe = import "~/Tribes/Network/JoinedTribe";
	-- RemoteEvent for members leaving a tribe
	-- Fired by the client to leave their current tribe
	-- Fired by the server to notify tribe members that a player has left the tribe
	LeaveTribe = import "~/Tribes/Network/LeaveTribe";
}

TribeCore.Jobs = {
	"Architect", "Baker", "Blacksmith", "Farmer",
	"Fisher", "Gatherer", "Guard", "Hunter", "Merchant",
	"Miner", "Shipmaker", "Unemployed"
}

-- The default job for players that do not have a specific job assigned.
TribeCore.DefaultJob = "Unemployed"

-- The invite modes a player can have.
-- A player's invite mode determines who can send them tribe invites.
TribeCore.InviteMode = {
	-- Everyone can send tribe invites to the player.
	Everyone = 0;
	-- Only the player's friends can send them invites.
	Friends = 1;
	-- Nobody can send the player tribe invites.
	Nobody = 2;
}

-- A reverse map of InviteMode -> string.
TribeCore.InviteModeStrings = {
	[TribeCore.InviteMode.Everyone] = "Everyone";
	[TribeCore.InviteMode.Friends] = "Friends";
	[TribeCore.InviteMode.Nobody] = "Nobody";
}

-- The failure reasons for creating a tribe.
TribeCore.CreationFailureReason = {
	-- The name was filtered by Roblox.
	NameFiltered = 0;
	-- The name is already taken.
	NameTaken = 1;
	-- The color is already taken.
	ColorTaken = 2;
	-- The owner is already in a tribe.
	AlreadyInTribe = 3;
	-- Creation was successful.
	Okay = 4;
}

-- The possible ranks in the tribe a player can have.
TribeCore.TribeRank = {
	-- The owner can do everything.
	Owner = 3;
	-- Managers can change jobs and invite new members.
	Manager = 2;
	-- Members are simply members of the tribe.
	Member = 1;
	-- An error result when a player is not in a tribe.
	NotInTribe = -1;
}

-- A reverse map of TribeRank -> string in the same fashion as InviteModeStrings.
TribeCore.TribeRankStrings = {
	[TribeCore.TribeRank.Owner] = "Owner";
	[TribeCore.TribeRank.Manager] = "Manager";
	[TribeCore.TribeRank.Member] = "Member";
}

-- Gets all the available, untaken colors.
-- Returns:
-- 	array<BrickColor>: All untaken colors available for new tribes to use.
function TribeCore.GetAvailableColors()
	local colors = {}
	local usedColors = {}

	-- Precompute all the used colors
	for _, team in ipairs(Teams:GetTeams()) do
		usedColors[team.BrickColor.Name] = true
	end

	for _, color in ipairs(TribeColors) do
		if not usedColors[color.Name] then
			table.insert(colors, color)
		end
	end

	return colors
end

-- Checks whether a player is in a tribe.
-- Arguments:
-- 	player (Player): the player to check the tribe of.
-- Returns:
-- 	boolean: whether the player is in a tribe.
function TribeCore.IsPlayerInTribe(player)
	assert(typeof(player) == "Instance" and player:IsA("Player"), "player (1) must be a Player.")

	-- Simple check: if they don't have a team, they can't be in a tribe.
	return player.Team ~= nil
end

function TribeCore.GetPlayerRank(player)
	if not TribeCore.IsPlayerInTribe(player) then
		return TribeCore.TribeRank.NotInTribe
	else
		return Data.Get(player.Team, "TribeRanks."..player.UserId)
	end
end

function TribeCore.GetPlayerJob(player)
	if not TribeCore.IsPlayerInTribe(player) then
		return ""
	else
		return Data.Get(player.Team, "TribeJobs."..player.UserId)
	end
end

function TribeCore.GetTribeOwner(tribeName)
	local tribeTeam = Teams:FindFirstChild(tribeName)
	return Data.Get(tribeTeam, "TribeOwner")
end

function TribeCore.GetPlayerTribeName(player)
	if not player.Team then
		return nil
	else
		return player.Team.Name
	end
end

function TribeCore.InSameTribe(player1, player2)
	return player1.Team == player2.Team and TribeCore.IsPlayerInTribe(player1) and TribeCore.IsPlayerInTribe(player2)
end

function TribeCore.GetTribeMembers(tribeName)
	local tribeTeam = Teams:FindFirstChild(tribeName)

	if tribeTeam then
		return tribeTeam:GetPlayers()
	else
		return {}
	end
end

-- All the reasons that players cannot invite a player to a tribe.
TribeCore.CannotInviteReason = {
	-- They can be invited.
	Okay = 0;
	-- They are in a tribe.
	InTribe = 1;
	-- Their invites are restricted to friends-only, and the player sending the invite is not friends with them.
	FriendsOnly = 2;
	-- Their invites are completely disabled.
	Disabled = 3;
	-- The inviter is not in a tribe.
	InviterNotInTribe = 4;
}

-- Checks whether a player can be invited to a tribe by another player.
-- Arguments:
-- 	inviter (Player): the player trying to send the invite.
-- 	invitee (Player): the player receiving the invite from `inviter`.
-- Returns:
-- 	boolean: Whether `invitee` can receive a tribe invite from `inviter`.
-- 	CannotInviteReason: Why `invitee` could not be invited. Is CannotInviteReason.Okay if the first return value is true.
function TribeCore.CanInviteToTribe(inviter, invitee)
	assert(typeof(inviter) == "Instance" and inviter:IsA("Player"), "inviter (1) must be a Player.")
	assert(typeof(invitee) == "Instance" and invitee:IsA("Player"), "invitee (2) must be a Player.")

	-- No need to go through GetPlayerTribe to simply check if they're in a tribe.
	-- If they're already in a tribe they can't receive an invitation for a new one.
	if TribeCore.IsPlayerInTribe(invitee) then
		return false, TribeCore.CannotInviteReason.InTribe
	end

	-- The inviter cannot invite someone to a tribe that they are not in.
	if not TribeCore.IsPlayerInTribe(inviter) then
		return false, TribeCore.CannotInviteReason.InviterNotInTribe
	end

	local setting = Data.Get(invitee, "TribeInvitations")
	
	-- If they've completely blocked tribe invites then the answer is always no.
	if setting == TribeCore.InviteMode.Nobody then
		return false, TribeCore.CannotInviteReason.Disabled
	-- If they're not friends with the inviter, the inviter can't send them an invite.
	elseif setting == TribeCore.InviteMode.FriendsOnly and not invitee:IsFriendsWith(inviter.UserId) then
		return false, TribeCore.CannotInviteReason.FriendsOnly
	end

	-- If we've not returned previously, nothing is blocking the invite.
	return true, TribeCore.CannotInviteReason.Okay
end

return TribeCore
