local MoveSystem = class("MoveSystem", System)

function MoveSystem:fireEvent(moveEvent)
    for index, target in pairs(engine:getEntitiesWithComponent("Block")) do
        local position = target:get("Position") 
        if moveEvent.x == position.x and moveEvent.y == position.y then
            --deny the move
            return
        end
    end

    --successful move
    local moverPosition = moveEvent.mover:get("Position")
    moverPosition.x = moveEvent.x
    moverPosition.y = moveEvent.y
    engine.turn = engine.turn + 1
    return
end

return MoveSystem