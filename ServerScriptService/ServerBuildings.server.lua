----------------------------------------
----- Constants ------------------------
----------------------------------------
local DEFAULT_DROPDOWN_TEXT = "(select player)"
local BUILDING_DESTROYED_MESSAGE = "Building destroyed!"

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local Create = Load "Create"
local DataAccessor = Load "Data.DataAccessor"
local SharedBuildings = Load "BuildingsMenu.SharedBuildings"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local remoteDeleteAttempt = Load "BuildingsMenu.DeleteAttempt"
local remoteRetoolAttempt = Load "BuildingsMenu.RetoolAttempt"
local remoteTransferAttempt = Load "BuildingsMenu.TransferAttempt"

local itemBin = Load "Items"

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function OnDeleteAttempt(player, building)

	if SharedBuildings.IsBuilding(building) and DataAccessor.Get(building, "Owner") == player then
		building:Destroy()
		--print("DELETED: "..player.Name.." just deleted their "..building.Name)

	end
end

local function OnRetoolAttempt(player, building)
	if SharedBuildings.IsBuilding(building) and DataAccessor.Get(building, "Owner") == player and not SharedBuildings.IsDestroyed(building) then
		local tool = itemBin:FindFirstChild(building.Name):Clone()
		building:Destroy()
		--print("RETOOLED: "..player.Name.." just retooled their "..building.Name)
		tool.Parent = player.Backpack
	end
end

local function OnTransferAttempt(player, building, destinationPlayer)
	if destinationPlayer == player or destinationPlayer == nil then
		return
	end
	
	if SharedBuildings.IsBuilding(building) and DataAccessor.Get(building, "Owner") == player and not SharedBuildings.IsDestroyed(building) then
		DataAccessor.Set(building, "Owner", destinationPlayer)
		DataAccessor.Set(building, "OwnerString", destinationPlayer.Name)
		--print("TRANSFERED: "..player.Name.." just transfered their "..building.Name.." to "..destinationPlayer.Name)
	end
end

----------------------------------------
----- Server Buildings -----------------
----------------------------------------
remoteDeleteAttempt.OnServerEvent:connect(OnDeleteAttempt)
remoteRetoolAttempt.OnServerEvent:connect(OnRetoolAttempt)
remoteTransferAttempt.OnServerEvent:connect(OnTransferAttempt)