require("events/MoveEvent")
local CommandKeySystem = class("CommandKeySystem", System)

function CommandKeySystem:fireEvent(CommandKeyEvent)
    if CommandKeyEvent.key == "up" then
        for index, entity in pairs(engine:getEntitiesWithComponent("Control")) do
            local position = entity:get("Position")
            eventManager:fireEvent(MoveEvent(entity, position.x, position.y-1))
        end
    elseif CommandKeyEvent.key == "down" then
        for index, entity in pairs(engine:getEntitiesWithComponent("Control")) do
            local position = entity:get("Position")
            eventManager:fireEvent(MoveEvent(entity, position.x, position.y+1))
        end
    elseif CommandKeyEvent.key == "right" then
        for index, entity in pairs(engine:getEntitiesWithComponent("Control")) do
            local position = entity:get("Position")
            eventManager:fireEvent(MoveEvent(entity, position.x+1, position.y))
        end
    elseif CommandKeyEvent.key == "left" then
        for index, entity in pairs(engine:getEntitiesWithComponent("Control")) do
            local position = entity:get("Position")
            eventManager:fireEvent(MoveEvent(entity, position.x-1, position.y))
        end
    end
end

return CommandKeySystem