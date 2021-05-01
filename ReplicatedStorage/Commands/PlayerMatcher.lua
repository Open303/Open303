local Players = game:GetService("Players")

local Wildcards = {
	all = function(sender)
		return Players:GetPlayers()
	end;
	others = function(sender)
		local players = Players:GetPlayers()
		
		for i = #players, 1, -1 do
			if players[i] == sender then
				table.remove(players, i)
				break
			end
		end
		
		return players
	end
}

local PlayerMatcher = {}

function PlayerMatcher.MatchInStrings(strings, searchString)
	searchString = searchString:lower()
	
	local resultSet = {}
	for chunk in searchString:gmatch("[^,]+") do
		if chunk ~= "" then
			for _, str in ipairs(strings) do
				if str:lower():sub(1, chunk:len()) == chunk then
					resultSet[str] = true
				end
			end
		end
	end
	
	local result = {}
	
	for str in pairs(resultSet) do
		table.insert(result, str)
	end
	
	return result
end

function PlayerMatcher.Match(sender, str, useWildcards)
	str = str:lower()
	
	if useWildcards and Wildcards[str] ~= nil then
		return Wildcards[str](sender)
	end
	
	local resultSet = {}
	for chunk in str:gmatch("[^,]+") do
		if chunk == "me" then
			resultSet[sender] = true
		elseif chunk ~= "" then
			for _, player in ipairs(Players:GetPlayers()) do
				if player.Name:lower():match("^"..chunk) then
					resultSet[player] = true
				end
			end
		end
	end
	
	local result = {}
	for player in pairs(resultSet) do
		table.insert(result, player)
	end
	
	return result
end

function PlayerMatcher.MatchSinglePlayer(str)
	str = str:lower()
	local selectedPlayer
	
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Name:lower():sub(1, str:len()) == str then
			if selectedPlayer then
				return nil
			else
				selectedPlayer = player
			end
		end
	end
	
	return selectedPlayer
end

return PlayerMatcher