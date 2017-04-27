game = {}
game.events = require "core.events.events"
game.systems = require "core.systems.systems"
function game.load(options)
    game.options = options
    game.state = "rogue"
    dofile('core/startup.lua')

    --shared info between systems
    game.time = 1
    game.systems.init()
    game.events.init()
    if not game.options.headless then
        game.events.fireEvent(game.events.LevelEvent{levelName="1-1", options=options, firstLevel=true})
    end
    game.events.fireEvent(game.events.FocusEvent{x=3,y=3})

end


function game.update(dt)
    game.time = game.time + dt
    systems.update(dt)
end

function game.draw()
    systems.draw()
end

function game.keypressed(key)
    game.events.fireEvent(game.events.KeyPressEvent({key=key}))
end
return game
