return {
	Hunger = {
		MaxValue = 100;
		MinValue = 0;
		StartingValue = 100;
		ResetValue = 50;
		Step = function(stats, delta)
			--Having over 25% saturation will completely halt hunger - interpolates between 25 and 0.
			local saturationEffect = 1 - math.min(1, stats.Saturation / 25)
			return stats.Hunger - (0.08 * saturationEffect * delta)
		end;
	};
	Thirst = {
		MaxValue = 100;
		MinValue = 0;
		StartingValue = 100;
		ResetValue = 50;
		Step = function(stats, delta)
			return stats.Thirst - (0.12 * delta)
		end;
	};
	Vitality = {
		MaxValue = 100;
		MinValue = 0;
		StartingValue = 100;
		ResetValue = 75;
		Step = function(stats, delta)
			local hungerFraction = 0.65 - (stats.Hunger / 100)
			local thirstFraction = 0.65 - (stats.Thirst / 100)
			local modifiedDepletion = (hungerFraction + thirstFraction) * delta * 0.225
			return stats.Vitality - modifiedDepletion
		end;
	};
	Saturation = {
		MaxValue = 100;
		MinValue = 0;
		StartingValue = 0;
		NonCritical = true;
		Step = function(stats, delta)
			if stats.Saturation < stats.Hunger then
				return stats.Saturation - (0.02 * delta)
			else
				return stats.Hunger - (0.02 * delta)
			end
		end;
	};
}