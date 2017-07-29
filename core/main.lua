local game = require "core.game"
function love.load()
    game.load({
        debug = false,
        headless = false,
        spriteSize = 48,
        player = true,
        auto = false
    })
end
function love.update(dt)
    game.update(dt)
end
function love.draw()
    game.draw()
end
function love.keypressed(key)
    game.keypressed(key)
end
