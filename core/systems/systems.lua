local lovetoys = require "lib.lovetoys.lovetoys"
if not lovetoys.initialized then lovetoys.initialize({
    globals = false,
    debug = true
})
end
systems = {}

function systems.init()

    --event systems
    local KeyPressSystem = require "core.systems.event.KeyPressSystem"
    local MoveSystem = require "core.systems.event.MoveSystem"
    local LogSystem = require "core.systems.event.LogSystem"
    local TurnSystem = require "core.systems.event.TurnSystem"
    local SaveSystem = require "core.systems.event.SaveSystem"
    local LevelSystem = require "core.systems.event.LevelSystem"
    local ReplaySystem = require "core.systems.event.ReplaySystem"
    local TargetSystem = require "core.systems.event.TargetSystem"
    local StateSystem = require "core.systems.event.StateSystem"
    local ReservesSystem = require "core.systems.event.ReservesSystem"
    local MissionSystem = require "core.systems.event.MissionSystem"
    local SpawnSystem = require "core.systems.event.SpawnSystem"

    --draw systems
    local SpriteSystem = require "core.systems.graphic.SpriteSystem"
    local PromptSystem = require "core.systems.graphic.PromptSystem"
    local CursorSystem = require "core.systems.graphic.CursorSystem"
    local InfoBoxSystem = require "core.systems.graphic.InfoBoxSystem"
    local MenuSystem = require "core.systems.graphic.MenuSystem"

    --engine instance
    systems.engine = lovetoys.Engine()

    --add event systems to table
    systems.logSystem = LogSystem()
    systems.commandKeyPressSystem = KeyPressSystem()
    systems.moveSystem = MoveSystem()
    systems.turnSystem = TurnSystem()
    systems.saveSystem = SaveSystem()
    systems.levelSystem = LevelSystem()
    systems.replaySystem = ReplaySystem()
    systems.targetSystem = TargetSystem()
    systems.stateSystem = StateSystem()
    systems.reservesSystem = ReservesSystem()
    systems.missionSystem = MissionSystem()
    systems.spawnSystem = SpawnSystem()

    --add draw systems to table
    if not game.options.headless then
        systems.spriteSystem = SpriteSystem()
        systems.promptSystem = PromptSystem()
        systems.cursorSystem = CursorSystem()
        systems.infoBoxSystem = InfoBoxSystem()
        systems.menuSystem = MenuSystem()

        --order of drawing
        systems.engine:addSystem(systems.spriteSystem, "draw")
        systems.engine:addSystem(systems.promptSystem, "draw")
        systems.engine:addSystem(systems.infoBoxSystem, "draw")
        systems.engine:addSystem(systems.cursorSystem, "draw")
        systems.engine:addSystem(systems.menuSystem, "draw")
    end
end

function systems.getEntitiesWithComponent(component)
    return systems.engine:getEntitiesWithComponent(component)
end

function systems.addEntity(entity)
    systems.engine:addEntity(entity)
end

function systems.getEntityById(entityId)
    return systems.engine.entities[entityId]
end

function systems.removeComponent(entity)
    return systems.engine.entities[entityId]
end

function systems.removeAllEntitiesExcept(entityToSpare)
    for k, e in pairs(systems.engine.entities) do
        if e.id ~= entityToSpare.id then
            systems.engine:removeEntity(e)
        end
    end
end

function systems.getLastEntity()
    return systems.engine.entities[#systems.engine.entities]
end
function systems.getEntities()
    return systems.engine.entities
end

function systems.update()
    love.graphics.setColor(255, 255, 255)
    systems.engine:update()
end

function systems.draw()
    systems.engine:draw()
end

return systems
