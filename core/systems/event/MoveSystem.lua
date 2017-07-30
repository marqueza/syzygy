local class = require "lib.middleclass"
local events = require "core.events.events"
local systems = require "core.systems.systems"
local MoveSystem = class("MoveSystem", System)

function MoveSystem:initialize()
    self.name = "Move System"
end

function MoveSystem:onNotify(moveEvent)
    local mover = systems.getEntityById(moveEvent.moverId)
    for index, target in pairs(systems.getEntitiesWithComponent("Physics")) do
        local Physics = target:get("Physics")
        if moveEvent.x == Physics.x and moveEvent.y == Physics.y then
          if (Physics.blocks == true) then
            local Faction = target:get("Faction")
            if (target:has("Faction")) then
                if mover.Faction.name ~= target.Faction.name then
                  events.fireEvent(events.AttackEvent{attackerId=mover.id, defenderId=target.id})
                end
            else
                events.fireEvent(events.LogEvent{text=mover.name .. " bumps " .. target.name})
            end
            return
          end
        end
    end

    --successful move
    local moverPhysics = mover:get("Physics")
    
    --reposition on the plane
    systems.planeSystem:reposition(mover, moveEvent.x, moveEvent.y)
    
    return
end

return MoveSystem
