local events = require "core.events.events"
local systems = require "core.systems.systems"
game = {}
function game.load(options)
    game.options = options
    dofile('core/startup.lua')

    --shared info between systems
    game.time = 1
    systems.init()
    events.init()
end


function game.update(dt)
    game.time = game.time + dt
    systems.update(dt)
end

function game.draw()
    systems.draw()
end

function game.keypressed(key)
    events.fireEvent(events.CommandKeyEvent(key))
end
return game
