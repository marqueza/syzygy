local lovetoys = require "lib.lovetoys.lovetoys"
local filer = require "data.filer"
if not lovetoys.initialized then lovetoys.initialize({
    globals = false,
    debug = true
})
end

local systems = {}
local _stackIndex = 0
local _entityStack = {}

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
        systems.engine:addSystem(systems.sideBarSystem, "draw")
    end
    filer.instantiateDirectoryItems(systems, "systems", "core/systems/update/" )
    filer.instantiateDirectoryItems(systems, "systems", "core/systems/ai/" )
    systems.engine:addSystem(systems.autoPressSystem, "update")
    
    
end

function systems.getEntitiesWithComponent(component)
    return systems.engine:getEntitiesWithComponent(component)
end

function systems.addEntity(entity)
  
    --assert(systems.engine.entities[entity.id] == nil)
    
    --add it to the engine
    systems.engine:addEntity(entity)
    
    --sorting entities by layers
    if systems.planeSystem and entity.Physics then
      systems.planeSystem:addToLayer(entity)
    end

    --add to stack
    _stackIndex = _stackIndex + 1
    _entityStack[_stackIndex] = entity

end

function systems.getEntityById(entityId)
    return systems.engine.entities[entityId]
end

function systems.removeEntity(entity)
  --remove from layering
    if systems.planeSystem and entity.Physics then
      systems.planeSystem:removeFromLayer(entity)
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
function systems.popEntity()
  if _stackIndex < 1 then return nil end
  local e =  _entityStack[_stackIndex]
  _stackIndex = _stackIndex-1
  return e
end
function systems.getEntities()
    return systems.engine.entities
end

function systems.getEntityByName(name)
  for entity in pairs(systems.engine.entities) do
    if entity.name == name then
      return entity
    end
  end
  return nil
end

function systems.update(dt)
    love.graphics.setColor(255, 255, 255)
    systems.engine:update(dt)
end

function systems.draw()
    systems.engine:draw()
end

return systems
