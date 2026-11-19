local Base = require("spells/catapult")
local Script = setmetatable({}, { __index = Base })
Script.__index = Script

function Script:apply(mechanics, server, target)
	self:applyEarthquake(mechanics:getBattle(), server, nil, mechanics:getEffectValue())
end

return Script