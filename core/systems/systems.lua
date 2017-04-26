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

    --draw systems
    local SpriteSystem = require "core.systems.graphic.SpriteSystem"
    local PromptSystem = require "core.systems.graphic.PromptSystem"
    local CursorSystem = require "core.systems.graphic.CursorSystem"
    local InfoBoxSystem = require "core.systems.graphic.InfoBoxSystem"

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

    --add draw systems to table
    if not game.options.headless then
        systems.spriteSystem = SpriteSystem()
        systems.promptSystem = PromptSystem()
        systems.cursorSystem = CursorSystem()
        systems.infoBoxSystem = InfoBoxSystem()

        --order of drawing
        systems.engine:addSystem(systems.spriteSystem, "draw")
        systems.engine:addSystem(systems.promptSystem, "draw")
        systems.engine:addSystem(systems.infoBoxSystem, "draw")
        systems.engine:addSystem(systems.cursorSystem, "draw")
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

function systems.getEntities(entityId)
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
