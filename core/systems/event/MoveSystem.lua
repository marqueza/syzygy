local events = require "core.events.events"
local MoveSystem = class("MoveSystem", System)

function MoveSystem:fireEvent(moveEvent)
    for index, target in pairs(engine:getEntitiesWithComponent("physics")) do
        local physics = target:get("physics")
        if moveEvent.x == physics.x and moveEvent.y == physics.y then
          if (physics.blocks == true) then
            local faction = target:get("faction")
            if (target:has("faction")) then
                if moveEvent.mover.faction.name ~= target.faction.name then
                  events.fireEvent(MessageEvent(moveEvent.mover.name .. " smacks ".. target.name))
                end
            else
                events.fireEvent(MessageEvent(moveEvent.mover.name .. " bumps " .. target.name))
            end
            engine.turn = engine.turn + 1
            return
          end
        end
    end

    --successful move
    local moverphysics = moveEvent.mover:get("physics")
    moverphysics.x = moveEvent.x
    moverphysics.y = moveEvent.y
    engine.turn = engine.turn + 1
    return
end

return MoveSystem
