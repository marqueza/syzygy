local lovetoys = require "lib.lovetoys.lovetoys"
local filer = require "data.filer"
if not lovetoys.initialized then lovetoys.initialize({
    globals = false,
    debug = true
})
end

local systems = {}

function systems.init()
    systems.engine = lovetoys.Engine()

    filer.instantiateDirectoryItems(systems, "systems", "core/systems/event/")

    if not game.options.headless then
        filer.instantiateDirectoryItems(systems, "systems", "core/systems/graphic/" )

        --order of drawing
        systems.engine:addSystem(systems.spriteSystem, "draw")
        systems.engine:addSystem(systems.promptSystem, "draw")
        systems.engine:addSystem(systems.statusBoxSystem, "draw")
        systems.engine:addSystem(systems.infoBoxSystem, "draw")
        systems.engine:addSystem(systems.cursorSystem, "draw")
        systems.engine:addSystem(systems.menuSystem, "draw")
    end
    if  game.options.auto then
        filer.instantiateDirectoryItems(systems, "systems", "core/systems/update/" )
        systems.engine:addSystem(systems.autoPressSystem, "update")
    end
    
end

function systems.getEntitiesWithComponent(component)
    return systems.engine:getEntitiesWithComponent(component)
end

function systems.addEntity(entity)
  
    assert(systems.engine.entities[entity.id] == nil)
    
    --add it to the engine
    systems.engine:addEntity(entity)
    
    --if we have sprite system, help it by sorting entities by layers
    if systems.spriteSystem and entity.Sprite then
      systems.spriteSystem:addToLayer(entity)
    end
end

function systems.getEntityById(entityId)
    return systems.engine.entities[entityId]
end

function systems.removeEntity(entity)
  --if we have sprite system, help it by removing from its layering
    if systems.spriteSystem and entity.Sprite then
      systems.spriteSystem:removeFromLayer(entity)
    end
    return systems.engine:removeEntity(entity)
end

function systems.removeEntityById(entityId)
  return systems.removeEntity(systems.engine.entities[entityId])
end

function systems.removeAllEntitiesExcept(entityToSpare)
    for k, e in pairs(systems.engine.entities) do
        if e.id ~= entityToSpare.id then
            systems.removeEntity(e)
        end
    end
end
function systems.removeAllEntities()
    for k, e in pairs(systems.engine.entities) do
        systems.removeEntity(e)
    end
end
function systems.getLastEntity()
    return systems.engine.entities[#systems.engine.entities]
end
function systems.getEntities()
    return systems.engine.entities
end

function systems.update(dt)
    love.graphics.setColor(255, 255, 255)
    systems.engine:update(dt)
end

function systems.draw()
    systems.engine:draw()
end

return systems
