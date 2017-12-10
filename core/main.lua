require "core.game"
function love.load(args)
    game.load(require "core.settings")
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
function love.quit()
    game.quit()
end
