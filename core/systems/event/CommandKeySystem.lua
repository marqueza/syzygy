require "core.events.MoveEvent"
local events = require "core.events.events"
local engine = require "core.engine"

local CommandKeySystem = class("CommandKeySystem", System)

function CommandKeySystem:fireEvent(CommandKeyEvent)
    if CommandKeyEvent.key == "up" then
        for index, entity in pairs(engine.getEntitiesWithComponent("control")) do
            local physics = entity:get("physics")
            events.fireEvent(MoveEvent(entity, physics.x, physics.y-1))
        end
    elseif CommandKeyEvent.key == "down" then
        for index, entity in pairs(engine.getEntitiesWithComponent("control")) do
            local physics = entity:get("physics")
            events.fireEvent(MoveEvent(entity, physics.x, physics.y+1))
        end
    elseif CommandKeyEvent.key == "right" then
        for index, entity in pairs(engine.getEntitiesWithComponent("control")) do
            local physics = entity:get("physics")
            events.fireEvent(MoveEvent(entity, physics.x+1, physics.y))
        end
    elseif CommandKeyEvent.key == "left" then
        for index, entity in pairs(engine.getEntitiesWithComponent("control")) do
            local physics = entity:get("physics")
            events.fireEvent(MoveEvent(entity, physics.x-1, physics.y))
        end
    end
end

return CommandKeySystem
