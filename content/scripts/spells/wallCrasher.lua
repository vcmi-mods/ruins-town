--- Parameters (both set in the spells json-configuration):
--- chanceToNormalHit: chance that a shot succeeds, Earthquake uses 100
--- chanceToCrit: chance that a shot does double damage, Earthquake uses 0

local Base = require("spells/catapult")
local Script = setmetatable({}, { __index = Base })
Script.__index = Script

function Script:apply(mechanics, server, target)
	--- explicitly passes nil as the attacking unit to play the screen-shake animation
	self:applyEarthquake(mechanics:getBattle(), server, nil, mechanics:getEffectValue())
end

return Script