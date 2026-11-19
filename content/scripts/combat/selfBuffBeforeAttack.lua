--- Parameters
--- spell: the spell to cast, required
--- onCounter: also buff when counterattacking
--- val: chance to cast the spell, required

local Base = require("combat/combatScript")
local Script = setmetatable({}, { __index = Base })
Script.__index = Script

function Script:onBeforeAttack(server, battle, unit, other, payload)
	if not unit:isAlive() or (payload.isCounter and not self.onCounter) then return end
	if not self.val or self.val <= 0 then return end

	local chance = math.min(math.max(self.val, 0), 100)

	if chance < 100 and server:rngInt(1,100) > chance then return end

	server:castSpell(battle, unit, LIBRARY:getSpellByName(self.spell), { unit }, 1)
end

return Script