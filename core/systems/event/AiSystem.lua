local class = require "lib.middleclass"
local events = require "core.events.events"
local systems = require "core.systems.systems"
local Serializable = require "data.serializable"
local AiSystem = class("AiSystem", System)
AiSystem:include(Serializable)

function AiSystem:initialize()
    self.name = "AiSystem"
    self.turn = 1
end

function AiSystem:onTurnNotify(TurnEvent)
    --go through all the entities with Ai and have them act
    for i, actorEntity in pairs(systems.getEntitiesWithComponent("Ai")) do
        local actionTaken = false
        if actorEntity.Ai.combatPreference == "melee" then
            --move closer to the opposing faction
            for j, opposingEntity in pairs(systems.getEntitiesWithComponent("Faction")) do
                if opposingEntity.Faction.name ~= actorEntity.Faction.name then
                    self:MoveEntityTo(actorEntity, opposingEntity)
                    actionTaken = true
                    break
                end
            end
        end

        --no enemies so now do the idle action
        if not actionTaken and actorEntity.Ai.idle and actorEntity.Ai.idle == "explore" then
            --try to rest if needed
            if actorEntity.Physics.hp < actorEntity.Physics.maxHp then
                actorEntity.Physics.hp = actorEntity.Physics.hp + 4
                return
            end


            --try to go downstairs
            for j, entranceEntity in pairs(systems.getEntitiesWithComponent("Entrance")) do
                if entranceEntity.Entrance.commandKey == "<" then
                    if actorEntity.Physics.x == entranceEntity.Physics.x and
                        actorEntity.Physics.y == entranceEntity.Physics.y then
                            events.fireEvent(events.LevelEvent{levelName=entranceEntity.Entrance.levelName})
                    else
                        self:MoveEntityTo(actorEntity, entranceEntity)
                    end
                    return
                end
            end

        end
    end

end

function AiSystem:MoveEntityTo(actorEntity, targetEntity)
    --determine direction
    local dx, dy = 0, 0
    if actorEntity.Physics.x > targetEntity.Physics.x then
        dx = -1
    elseif actorEntity.Physics.x < targetEntity.Physics.x then
        dx = 1
    end
    if actorEntity.Physics.y > targetEntity.Physics.y then
        dy = -1
    elseif actorEntity.Physics.y < targetEntity.Physics.y then
        dy = 1
    end

    events.fireEvent(events.MoveEvent( {
    moverId=actorEntity.id,
    x=actorEntity.Physics.x + dx,
    y=actorEntity.Physics.y + dy,
    }))
    return
end


return AiSystem
