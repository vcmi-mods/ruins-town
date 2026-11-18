--- Parameters:
--- val: chance to trigger
--- evadeMelee: melee reduction
--- evadeRanged: ranged reduction

local Base = require("combat/combatScript")
local Script = setmetatable({}, { __index = Base })
Script.__index = Script

local SOURCE_KEY = "ruinsDodge"
local ANIMATION = "spells/dodge/dodge.def"
local SOUND = "dodge.mp3"

local function clamp(value)
	return math.min(math.max(value, 0), 100)
end

function Script:addDodgeBonus(server, battle, unit, ranged)
	local magnitude = 0

	if ranged then
		magnitude = clamp(self.evadeRanged or 0)
	else
		magnitude = clamp(self.evadeMelee or 0)
	end

	if magnitude <= 0 then
		return false
	end

	server:addUnitBonus(battle, unit, {
		type = "GENERAL_DAMAGE_REDUCTION",
		subtype = ranged and "damageTypeRanged" or "damageTypeMelee",
		val = magnitude,
		valueType = "ADDITIVE_VALUE",
		sourceType = "OTHER",
		sourceID = SOURCE_KEY,
		duration = "ONE_BATTLE"
	}, false)

	return true
end

function Script:onBeforeAttacked(server, battle, unit, other, payload)
	if self.val <= 0 then return end
	local chance = clamp(self.val or 0)

	if chance < 100 and server:rngInt(1,100) > chance then return end

	local animate = self:addDodgeBonus(server, battle, unit, payload.ranged)

	if animate then
		server:showBattleAnimation(battle, { { unit = unit } }, ANIMATION, SOUND, 1.0, false)
	end
end

function Script:onAfterAttacked(server, battle, unit, other, payload)
	server:removeUnitBonuses(battle, unit, unit:getBonuses({sourceID = SOURCE_KEY}))
end

return Script