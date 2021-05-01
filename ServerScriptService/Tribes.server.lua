local Chat = game:GetService("Chat")
local HttpService = game:GetService("HttpService")
local Teams = game:GetService("Teams")

local import = require(game:GetService("ReplicatedStorage"):WaitForChild("Import"))
local Data = import "~/Data/DataAccessor"
local TribeCore = import "~/Tribes/TribeCore"

-- Stores invites in the form [tribeName] = { [UserId] = true, ... }
local invites = {}

local function ChangePlayerRank(target, rank)
	if not TribeCore.IsPlayerInTribe(target) then return end

	local tribeTeam = target.Team
	Data.Set(tribeTeam, "TribeRanks."..target.UserId, rank)

	for _, member in ipairs(tribeTeam:GetPlayers()) do
		TribeCore.ChangeRank:FireClient(member, target, rank)
	end
end

local function ChangePlayerJob(target, job)
	if not TribeCore.IsPlayerInTribe(target) then return end

	local tribeTeam = target.Team
	Data.Set(tribeTeam, "TribeJobs."..target.UserId, job)

	for _, member in ipairs(tribeTeam:GetPlayers()) do
		TribeCore.ChangeRank:FireClient(member, target, job)
	end
end

local function ChangeTribeOwner(tribeName, newOwner)
	local tribeTeam = Teams:FindFirstChild(tribeName)
	if not tribeTeam or tribeTeam ~= newOwner.Team then return end

	local existingOwner = Data.Get(tribeTeam, "TribeOwner")

	if existingOwner.Team == tribeTeam then
		ChangeRank(existingOwner, TribeCore.TribeRank.Manager)
	end

	Data.Set(tribeTeam, "TribeOwner", newOwner)
	ChangeRank(newOwner, TribeCore.TribeRank.Owner)

	for _, member in ipairs(tribeTeam:GetPlayers()) do
		TribeCore.ChangeOwner:FireClient(member, newOwner)
	end
end

local function JoinTribe(tribeName, player, rank)
	-- They can't join a tribe when they're already in one.
	if TribeCore.IsPlayerInTribe(player) then
		return
	end

	local tribeTeam = Teams:FindFirstChild(tribeName)

	if not tribeTeam then
		warn("TribeServer.JoinTribe: Tried to join nonexistent tribe "..tribeName)
		return
	end

	-- Add them to the team.
	player.TeamColor = tribeTeam.TeamColor
	-- Set their rank now.
	Data.Set(tribeTeam, "TribeRanks."..player.UserId, rank or TribeCore.TribeRank.Member)

	-- Tell the other members of the tribe that the new member joined
	for _, member in ipairs(tribeTeam:GetPlayers()) do
		if member ~= player then
			TribeCore.Network.JoinedTribe:FireClient(member, player)
		end
	end

	-- Then tell the player that they joined the tribe
	TribeCore.Network.JoinTribe:FireClient(player, tribeName)
end

local function DestroyTribe(tribeName)
	local tribeTeam = Teams:FindFirstChild(tribeName)

	for _, member in ipairs(tribeTeam:GetPlayers()) do
		member.TeamColor = nil
	end

	tribeTeam:Destroy()
end

local function LeaveTribe(player)
	-- They can't leave their current tribe if they're not in one.
	if not TribeCore.IsPlayerInTribe(player) then
		return
	end

	local tribeName = TribeCore.GetPlayerTribeName(player)
	local isOwner = TribeCore.GetTribeOwner(tribeName) == player

	local tribeTeam = player.Team
	-- Clear out the player's rank and job data.
	Data.Set(tribeTeam, "TribeRanks."..player.UserId, nil)
	Data.Set(tribeTeam, "TribeJobs."..player.UserId, nil)

	-- Tell the tribe members that the player left.
	for _, member in ipairs(tribeTeam:GetPlayers()) do
		TribeCore.Network.LeaveTribe:FireClient(member, tribeTeam.Name, player)
	end

	-- Actually remove them from the tribe.
	player.TeamColor = nil

	-- Is the owner leaving?
	-- If so, need to transfer the group.
	-- Transfer goes to the highest-rank member in the group, selected arbitrarily if there is more than one member of the same rank.
	if isOwner then
		local bestOption, bestOptionRank = nil, -1
		for _, member in ipairs(TribeCore.GetTribeMembers(tribeName)) do
			if member ~= player then
				local rank = TribeCore.GetPlayerRank(member)

				if rank > bestOptionRank then
					bestOptionRank = rank
					bestOption = member
				end
			end
		end

		if bestOption then
			ChangeTribeOwner(tribeName, bestOption)
		end
	end

	if #tribeTeam:GetPlayers() == 0 then
		DestroyTribe(tribeName)
	end
end

local function CreateTribe(owner, tribeName, tribeColor)
	-- Can't create a tribe if they're already in one; they need to leave it first.
	if TribeCore.IsPlayerInTribe(owner) then
		return false, TribeCore.CreationFailureReason.AlreadyInTribe
	end

	local filteredName = Chat:FilterStringForBroadcast(tribeName, owner)

	-- If the filtered name differs from the supplied name it was filtered.
	-- Instead of using the filtered name without the owner's consent, don't create the tribe.
	if filteredName ~= tribeName then
		return false, TribeCore.CreationFailureReason.NameFiltered
	end

	-- Sanity checks: is the name taken?
	if Teams:FindFirstChild(tribeName) then
		return false, TribeCore.CreationFailureReason.NameTaken
	end

	-- Sanity checks, part 2: is the color taken?
	-- This one in particular is critical
	-- Roblox does not appreciate having two teams with the same color.
	for _, team in ipairs(Teams:GetTeams()) do
		if team.TeamColor == tribeColor then
			return false, TribeCore.CreationFailureReason.ColorTaken
		end
	end

	local team = Instance.new("Team")
	team.Name = tribeName
	team.TeamColor = tribeColor

	-- Initialize the tribe data
	Data.Set(team, "Owner", owner)
	Data.Set(team, "TribeJobs", {})
	Data.Set(team, "TribeRanks", {})

	-- Parent it to Teams so it's accessible as a tribe
	team.Parent = Teams

	invites[tribeName] = {}

	-- Make the owner join the tribe.
	JoinTribe(tribeName, owner, TribeCore.TribeRank.Owner)
	return true, TribeCore.CreationFailureReason.Okay
end

-- Sends an invite from a player to another player, inviting them to join the inviter's tribe.
-- Arguments:
-- 	inviter (Player): the player sending the invite.
-- 	invitee (Player): the player receiving the invite.
-- Returns:
-- 	boolean: Whether the invite succeeded.
-- 	CannotInviteReason: The reason the invite failed, or CannotInviteReason.Okay if the invite succeeded.
local function Invite(inviter, invitee)
	local canInvite, failureReason = TribeCore.CanInviteToTribe(inviter, invitee)

	if not canInvite then
		return canInvite, failureReason
	end

	invites[inviter.Team.Name][invitee.UserId] = true
	TribeCore.Network.HandleInvite:FireClient(invitee, inviter, inviter.Team.Name)
	return true, TribeCore.CannotInviteReason.Okay
end

local function AcceptInvite(player, tribeName)
	local hasInvite = invites[tribeName] and invites[tribeName][player.UserId]
	if not hasInvite then return end
	invites[tribeName][player.UserId] = nil
	JoinTribe(tribeName, player)
end

TribeCore.Network.CreateTribe.OnServerInvoke = CreateTribe
TribeCore.Network.SendInvite.OnServerInvoke = Invite
TribeCore.Network.LeaveTribe.OnServerEvent:Connect(LeaveTribe)
TribeCore.Network.ChangeJob.OnServerEvent:Connect(function(changer, target, job)
	if not TribeCore.InSameTribe(changer, target) then return end
	if not TribeCore.Jobs[job] then return end
	if TribeCore.GetPlayerRank(changer) < TribeCore.TribeRank.Manager then return end

	local tribeTeam = Teams:FindFirstChild(TribeCore.GetPlayerTribeName(changer))
	Data.Set(tribeTeam, "TribeJobs."..target.UserId, job)

	for _, member in ipairs(tribeTeam:GetPlayers()) do
		TribeCore.Network.ChangeJob:FireClient(member, target, job)
	end
end)

TribeCore.Network.ChangeRank.OnServerEvent:Connect(function(changer, target, rank)
	if not TribeCore.InSameTribe(changer, target) then return end
	if not TribeCore.Jobs[job] then return end
	if TribeCore.GetPlayerRank(changer) <= rank then return end
	if TribeCore.GetPlayerRank(changer) <= TribeCore.GetPlayerRank(target) then return end

	local tribeTeam = Teams:FindFirstChild(TribeCore.GetPlayerTribeName(changer))
	Data.Set(tribeTeam, "TribeRanks."..target.UserId, rank)

	for _, member in ipairs(tribeTeam:GetPlayers()) do
		TribeCore.Network.ChangeJob:FireClient(member, target, job)
	end
end)

TribeCore.Network.ChangeOwner.OnServerEvent:Connect(function(changer, target)
	if not TribeCore.InSameTribe(changer, target) then return end
	if not TribeCore.Jobs[job] then return end

	local tribeName = TribeCore.GetPlayerTribeName(changer)
	local 
end)