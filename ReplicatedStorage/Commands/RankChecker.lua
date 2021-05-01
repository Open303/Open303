local RunService = game:GetService("RunService")

local MODERATOR_RANK = 251
local ADMIN_RANK = 252
local DEVELOPER_RANK = 254
local GROUP_ID = 2915350

local rankNames = {
	[MODERATOR_RANK] = "Moderator";
	[ADMIN_RANK] = "Administrator";
	[DEVELOPER_RANK] = "Developer";
}

local rankCache = {
	[42577569] = 254 --NoBanana
}

local RankChecker = {}

RankChecker.MODERATOR_RANK = MODERATOR_RANK
RankChecker.ADMIN_RANK = ADMIN_RANK
RankChecker.DEVELOPER_RANK = DEVELOPER_RANK

function RankChecker.GetGroupRank(player)
	if RunService:IsStudio() then
		return DEVELOPER_RANK
	end
	
	if rankCache[player.UserId] == nil then
		rankCache[player.UserId] = player:GetRankInGroup(GROUP_ID)
	end
	
	return rankCache[player.UserId]	
end

function RankChecker.GetRankName(player)
	return rankNames[RankChecker.GetGroupRank(player)] or ""
end

function RankChecker.IsStaff(player)
	return RankChecker.GetGroupRank(player) >= MODERATOR_RANK
end

-- Purely informational. Generated by:
--[[
local staffList = {
	{ "SCARFACIAL", "Chiefwaffles", "halofan987123", "blargety", "MemoryAddress", "worldcrasher" },
	{ "DaredevilDJ" },
	{ "bugslinger", "pokemaster787", "chaoman12", "EvilShogun", "Narcoblix" },
	{ "demiurgic", "ultrabug", "cat8923", "D3m0nicAngel", "FlamePrince", "KIexos" }
}

for _, rankList in ipairs(staffList) do
	for index, name in ipairs(rankList) do
		local success, userId = pcall(function() return game:GetService("Players"):GetUserIdFromNameAsync(name) end)
		if success then
			rankList[index] = userId
		end
	end
end

print("{")
for _, rankList in ipairs(staffList) do
	local parts = { "\t{ " }

	for _, id in ipairs(rankList) do
		table.insert(parts, id)
		table.insert(parts, ", ")
	end

	table.remove(parts, #parts)
	table.insert(parts, " },")
	print(table.concat(parts, ""))
end
print("}")
]]

function RankChecker.GetStaff()
	return {
		{ 6282390, 5085568, 4511877, 14553640, 41345114, 22741940 },
		{ 1066512 },
		{ 38363, 6390068, 2617639, 7255005, 11815210 },
		{ 18577104, 25290541, 4305053, 467435, 699526, 16595625 },
	}
end

return RankChecker
