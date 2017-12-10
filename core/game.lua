game = {}
game.events = require "core.events.events"
game.systems = require "core.systems.systems"
function game.load(options)
    game.options = options or require "core.settings"
    game.state = "command"
    dofile('core/startup.lua')

    --shared info between systems
    game.time = 1
    game.systems.init()
    game.events.init()

    if game.options.headless then
      --bring the events and systems modules to global
      for k, v in pairs(game.events) do _G[k] = v end
      for k, v in pairs(game.systems) do _G[k] = v end
    else
        game.events.fireEvent(game.events.TitleEnterEvent{})
    end
    
end


function game.update(dt)
    game.time = game.time + dt
    game.fps = love.timer.getFPS()
    game.systems.update(dt)
end

function game.draw()
    game.systems.draw()
end

function game.keypressed(key)
    game.events.fireEvent(game.events.KeyPressEvent({key=key}))
end

function game.quit()
  game.events.fireEvent(game.events.SaveEvent{})
end
return game
