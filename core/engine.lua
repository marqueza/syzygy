local engine = {}

function engine.init()
    --engine instance
    engine.instance = Engine()

    --add draw systems to engine
    if not game.options.headless then
        print("GUI ON")
        engine.instance:addSystem(SpriteSystem(), "draw")
        engine.instance:addSystem(PromptSystem(), "draw")
    end

    --add entities to engine
    Map.Build.Arena(engine.addEntity)

end
function engine.getEntitiesWithComponent(component)
    return engine.instance:getEntitiesWithComponent(component)
end
function engine.addEntity(entity)
    engine.instance:addEntity(entity)
end
function engine.update()
    love.graphics.setColor(255, 255, 255)
    engine.instance:update()
end
function engine.draw()
    engine.instance:draw()
end
return engine
