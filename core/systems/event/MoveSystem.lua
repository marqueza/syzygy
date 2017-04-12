local class = require "lib.middleclass"
local events = require "core.events.events"
local systems = require "core.systems.systems"
local MoveSystem = class("MoveSystem", System)

function MoveSystem:initialize()
    self.name = "Move System"
end

function MoveSystem:onNotify(moveEvent)
    for index, target in pairs(systems.getEntitiesWithComponent("physics")) do
        local physics = target:get("physics")
        if moveEvent.x == physics.x and moveEvent.y == physics.y then
          if (physics.blocks == true) then
            local faction = target:get("faction")
            if (target:has("faction")) then
                if moveEvent.mover.faction.name ~= target.faction.name then
                  events.fireEvent(events.MessageEvent(moveEvent.mover.name .. " smacks ".. target.name))
                end
            else
                events.fireEvent(events.MessageEvent(moveEvent.mover.name .. " bumps " .. target.name))
            end
            events.fireEvent(events.TurnEvent())
            return
          end
        end
    end

    --successful move
    local moverphysics = moveEvent.mover:get("physics")
    moverphysics.x = moveEvent.x
    moverphysics.y = moveEvent.y
    events.fireEvent(events.TurnEvent())
    return
end

return MoveSystem
