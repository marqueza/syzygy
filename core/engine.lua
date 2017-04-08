dofile('core/includes.lua')
function love.load()
    dofile('core/startup.lua')
    --engine instance
    engine = Engine()

    --add draw systems to engine
    engine:addSystem(SpriteSystem(), "draw")
    engine:addSystem(PromptSystem(), "draw")

    --add entities to engine
    Map.Build.Arena()

    --shared info between systems
    engine.time = 1
    engine.turn = 1
    engine.log = {"", ""}

    events.load()
end


function love.update(dt)
    engine.time = engine.time + dt
    engine:update(dt)
end

function love.draw()
    love.graphics.setColor(255, 255, 255)
    engine:draw()
end

function love.keypressed(key)
    events.fireEvent(CommandKeyEvent(key))
end
