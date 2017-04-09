dofile('core/includes.lua')
local events = require "core.events.events"
local engine = require "core.engine"
game = {}
function game.load(options)
    game.options = options
    dofile('core/startup.lua')

    --shared info between systems
    game.time = 1
    game.turn = 1
    game.log = {"", ""}
    engine.init()
    events.init()
end


function game.update(dt)
    game.time = game.time + dt
    engine.update(dt)
end

function game.draw()
    engine.draw()
end

function game.keypressed(key)
    events.fireEvent(CommandKeyEvent(key))
end
return game
