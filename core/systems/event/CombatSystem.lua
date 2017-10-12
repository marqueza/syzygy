local class = require "lib.middleclass"
local CombatSystem = class("CombatSystem", System)
local events = require "core.events.events"
local systems = require "core.systems.systems"
local components = require "core.components.components"
CombatSystem:include()

--Combat system governs the rules of combat
function CombatSystem:initialize()
    self.name = "CombatSystem"
end

function CombatSystem:onAttackNotify(attackEvent)
    local attacker = systems.getEntityById(attackEvent.attackerId)
    local defender = systems.getEntityById(attackEvent.defenderId)
    assert(attacker.Stats, "'Stats' is missing for attacker")
    assert(defender.Stats, "'Stats' is missing for defender")
    if not attacker.Skills then attacker:add(components.Skills({})) end
    if not defender.Skills then defender:add(components.Skills({})) end
    
    events.fireEvent(events.LogEvent{text=attacker.name .. " smashes the ".. defender.name})
    defender.Stats.hp = defender.Stats.hp - self:meleeDamage(attacker)
    if defender.Stats.hp <= 0 then
        --gain exp for attacker
        systems.expSystem:gainExp(attacker, 10)
        events.fireEvent(events.DeathEvent{entityId=defender.id})
    end
end

function CombatSystem:meleeDamage(attacker)
  return math.ceil(attacker.Skills.strike/10 * (attacker.Stats.str/2 + attacker.Stats.dex/4))
end

return CombatSystem
