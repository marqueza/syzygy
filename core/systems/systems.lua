local lovetoys = require "lib.lovetoys.lovetoys"
if not lovetoys.initialized then lovetoys.initialize({
    globals = false,
    debug = true
})
end
systems = {}

function systems.init()

    local CommandKeySystem = require "core.systems.event.CommandKeySystem"
    local MoveSystem = require "core.systems.event.MoveSystem"
    local SpriteSystem = require "core.systems.graphic.SpriteSystem"
    local PromptSystem = require "core.systems.graphic.PromptSystem"
    local MessageSystem = require "core.systems.event.MessageSystem"
    local TurnSystem = require "core.systems.event.TurnSystem"
    local SaveSystem = require "core.systems.event.SaveSystem"
    local LevelSystem = require "core.systems.event.LevelSystem"

    --engine instance
    systems.engine = lovetoys.Engine()

    --add event systems to table
    systems.messageSystem = MessageSystem()
    systems.commandKeySystem = CommandKeySystem()
    systems.moveSystem = MoveSystem()
    systems.turnSystem = TurnSystem()
    systems.saveSystem = SaveSystem()
    systems.levelSystem = LevelSystem()

    --add draw systems to table
    if not game.options.headless then
        systems.SpriteSystem = SpriteSystem()
        systems.promptSystem = PromptSystem()

        systems.engine:addSystem(systems.SpriteSystem, "draw")
        systems.engine:addSystem(systems.promptSystem, "draw")
    end

end
function systems.getEntitiesWithComponent(component)
    return systems.engine:getEntitiesWithComponent(component)
end
function systems.addEntity(entity)
    systems.engine:addEntity(entity)
end
function systems.update()
    love.graphics.setColor(255, 255, 255)
    systems.engine:update()
end
function systems.draw()
    systems.engine:draw()
end
return systems
