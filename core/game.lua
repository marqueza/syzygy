game = {}
game.events = require "core.events.events"
game.systems = require "core.systems.systems"
function game.load(options)
    game.options = options
    game.state = "command"
    dofile('core/startup.lua')

    --shared info between systems
    game.time = 1
    game.systems.init()
    game.events.init()
    if not game.options.headless then
        game.events.fireEvent(game.events.LevelEvent{levelName="tower", options={levelDepth=1, first=true, spawnPlayer=options.player, spawnMinion=options.auto}})
        game.events.fireEvent(game.events.SpawnEvent{name="Gold", amount=100, stock=true})
    end
end


function game.update(dt)
    game.time = game.time + dt
    game.fps = love.timer.getFPS()
    systems.update(dt)
end

function game.draw()
    systems.draw()
end

function game.keypressed(key)
    game.events.fireEvent(game.events.KeyPressEvent({key=key}))
end
return game
