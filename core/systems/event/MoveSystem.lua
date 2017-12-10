local class = require "lib.middleclass"
local events = require "core.events.events"
local systems = require "core.systems.systems"
local MoveSystem = class("MoveSystem", System)

function MoveSystem:initialize()
    self.name = "Move System"
end
-- This is when we know we want to move here.
function MoveSystem:onNotify(moveEvent)
    local mover = systems.getEntityById(moveEvent.moverId)
    assert(mover, "MoveSystem: could not find mover " .. moveEvent.moverId)
    if not systems.planeSystem:isFloorSpace(moveEvent.x, moveEvent.y, mover.Physics.plane) then
      events.fireEvent(events.LogEvent{text=mover.name .. " bumps wall."})
      return
    end
    for index, target in pairs(systems.getEntitiesWithComponent("Physics")) do
        local Physics = target:get("Physics")
        if moveEvent.x == target.Physics.x and moveEvent.y == target.Physics.y and mover.Physics.plane == target.Physics.plane then
          if (Physics.blocks == true) then
            local Faction = target:get("Faction")
            if (target:has("Faction")) then
                if mover.Faction.name ~= target.Faction.name then
                  events.fireEvent(events.AttackEvent{attackerId=mover.id, defenderId=target.id})
                elseif game.player.id == mover.id and mover.Faction.name == target.Faction.name then
                  systems.planeSystem:reposition(target, mover.Physics.x,  mover.Physics.y)
                  systems.planeSystem:reposition(mover, moveEvent.x, moveEvent.y)
                end
            elseif target.Door then
              target.Door:open(target)
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
