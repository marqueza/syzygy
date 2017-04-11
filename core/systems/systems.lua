local lovetoys = require "lib.lovetoys.lovetoys"
lovetoys.initialize({
    globals = false,
    debug = true
})
local map = require 'core.factories.map.Map'
systems = {}

function systems.init()

    local CommandKeySystem = require "core.systems.event.CommandKeySystem"
    local MoveSystem = require "core.systems.event.MoveSystem"
    local SpriteSystem = require "core.systems.graphic.SpriteSystem"
    local PromptSystem = require "core.systems.graphic.PromptSystem"
    local MessageSystem = require "core.systems.event.MessageSystem"
    local TurnSystem = require "core.systems.event.TurnSystem"

    --engine instance
    systems.engine = lovetoys.Engine()

    --add event systems to table
    systems.messageSystem = MessageSystem()
    systems.commandKeySystem = CommandKeySystem()
    systems.moveSystem = MoveSystem()
    systems.turnSystem = TurnSystem()

    --add draw systems to table
    if not game.options.headless then
        systems.spriteSystem = SpriteSystem()
        systems.promptSystem = PromptSystem()

        systems.engine:addSystem(systems.spriteSystem, "draw")
        systems.engine:addSystem(systems.promptSystem, "draw")
    end

    --add entities to engine
    map.Build.Arena(systems.addEntity)

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
