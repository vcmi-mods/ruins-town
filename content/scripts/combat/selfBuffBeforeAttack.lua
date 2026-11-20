--- Parameters
--- spell: the spell to cast, required and validated through the schema
--- onCounter: also buff when counter-attacking, optional (default = false)
--- val: chance to cast the spell, optional (default = 0)

local Base = require("combat/combatScript")
local Script = setmetatable({}, { __index = Base })
Script.__index = Script

function Script:onBeforeAttack(server, battle, unit, other, payload)
	if not unit:isAlive() or (payload.isCounter and not self.onCounter) then return end
	if not self.val or self.val <= 0 then return end

	local chance = self.val

	if chance < 100 and not server:rollCombatAbility(battle, unit, chance) then return end

	server:castSpell(battle, unit, LIBRARY:getSpellByName(self.spell), { unit }, 1)
end

return Script