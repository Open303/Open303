-- Information about the environment that the game is running in.
-- Used to locate containers, hold version info, etc.

local Environment = {
	Containers = {
		Startup = workspace:WaitForChild("StartupObjects");
		Terrain = workspace:WaitForChild("Islands");
		MapResources = workspace:WaitForChild("Resources");
	};
}

Environment.ProductionServer = game.PlaceId == 480485987

return Environment