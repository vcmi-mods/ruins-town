--- Parameters:
--- val: chance to trigger, optional (default = 0)
--- evadeMelee: melee reduction magnitude, required and validated between 0 and 100 (inclusive)
--- evadeRanged: ranged reduction magnitude, required and validated between 0 and 100 (inclusive)

local Base = require("combat/combatScript")
local Script = setmetatable({}, { __index = Base })
Script.__index = Script

local SOURCE_KEY = "ruinsDodge"
local ANIMATION = "spells/dodge/dodge.def"
local SOUND = "dodge.mp3"

--- Returns the reduction magnitude
function Script:getMagnitude(ranged)
	local magnitude = 0

	if ranged then
		magnitude = self.evadeRanged or 0
	else
		magnitude = self.evadeMelee or 0
	end

	return math.min(magnitude, 100)
end

function Script:onBeforeAttacked(server, battle, unit, other, payload)
	local ranged = payload.ranged
	local magnitude = self:getMagnitude(ranged)

	if magnitude <= 0 then return end
	if not self.val or self.val <= 0 then return end
	local chance = self.val

	if chance < 100 and not server:rollCombatAbility(battle, unit, chance) then return end

	server:addUnitBonus(battle, unit, {
		type = "GENERAL_DAMAGE_REDUCTION",
		subtype = ranged and "damageTypeRanged" or "damageTypeMelee",
		val = magnitude,
		valueType = "ADDITIVE_VALUE",
		sourceType = "OTHER",
		sourceID = SOURCE_KEY,
		duration = "ONE_BATTLE"
	}, false)

	server:showBattleAnimation(battle, { { unit = unit } }, ANIMATION, SOUND, 1.0, false)
end

function Script:onAfterAttacked(server, battle, unit, other, payload)
	server:removeUnitBonuses(battle, unit, unit:getBonuses({sourceID = SOURCE_KEY}))
end

return Script