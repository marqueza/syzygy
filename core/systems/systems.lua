local lovetoys = require "lib.lovetoys.lovetoys"
local filer = require "data.filer"
if not lovetoys.initialized then lovetoys.initialize({
    globals = false,
    debug = true
})
end

systems = {}

function systems.init()
    systems.engine = lovetoys.Engine()
    
    filer.instantiateDirectoryItems(systems, "systems", "core/systems/event/")

    if not game.options.headless then
        filer.instantiateDirectoryItems(systems, "systems", "core/systems/graphic/" )

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
