dofile('core/includes.lua')
local events = require "core.events.events"
game = {}
function game.load(options)
    game.options = options
    dofile('core/startup.lua')

    --engine instance
    engine = Engine()

    --add draw systems to engine
    if not game.options.headless then
        print("GUI ON")
        engine:addSystem(SpriteSystem(), "draw")
        engine:addSystem(PromptSystem(), "draw")
    end

    --add entities to engine
    Map.Build.Arena()
    --set player
    game.player = Factory.Player(3,3)
	engine:addEntity(game.player)

    --shared info between systems
    engine.time = 1
    engine.turn = 1
    engine.log = {"", ""}
    events.register()
end


function game.update(dt)
    engine.time = engine.time + dt
    engine:update(dt)
end

function game.draw()
    love.graphics.setColor(255, 255, 255)
    engine:draw()
end

function game.keypressed(key)
    events.fireEvent(CommandKeyEvent(key))
end
return game
