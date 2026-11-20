local Base = require("combat/combatScript")
local Script = setmetatable({}, { __index = Base })
Script.__index = Script

--- Expert Earthquake (on battle start) hits 4 wall parts, Basic Earthquake (after attack) hits 2
local DAMAGED_PARTS_BEGINNING = 4
local DAMAGED_PARTS_ATTACK = 2

--- Checks the general applicability and passes the number of wall parts damaged to the helper spell
function Script:castWallCrasher(server, battle, unit, shots)
	if not (battle:hasFortifications() and unit:getSide() == ENUM.BattleSide.attacker) then return end
	local spell = LIBRARY:getSpellByName("rn_wallCrasher")
	server:castSpell(battle, unit, spell, {}, shots)
end

function Script:onAfterAttack(server, battle, unit, other, payload)
	self:castWallCrasher(server, battle, unit, DAMAGED_PARTS_ATTACK)
end

function Script:onBattleStart(server, battle, unit, other)
	self:castWallCrasher(server, battle, unit, DAMAGED_PARTS_BEGINNING)
end

return Script