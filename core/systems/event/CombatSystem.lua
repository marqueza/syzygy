local class = require "lib.middleclass"
local CombatSystem = class("CombatSystem", System)
local events = require "core.events.events"
local systems = require "core.systems.systems"
CombatSystem:include()

--Combat system governs the rules of combat
function CombatSystem:initialize()
    self.name = "CombatSystem"
end

function CombatSystem:onAttackNotify(attackEvent)
    local attacker = systems.getEntityById(attackEvent.attackerId)
    local defender = systems.getEntityById(attackEvent.defenderId)
    events.fireEvent(events.LogEvent{text=attacker.name .. " smashes the ".. defender.name})
    defender.Physics.hp = defender.Physics.hp - 1
    if defender.Physics.hp <= 0 then
        events.fireEvent(events.LogEvent{text=defender.name .. " dies."})
        systems.removeEntity(defender)
    end
end

return CombatSystem
