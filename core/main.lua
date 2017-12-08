local game = require "core.game"
local cute = require "lib.cute"
function love.load(args)
    cute.go(args)
    game.load(require "core.settings")
end
function love.update(dt)
    game.update(dt)
end
function love.draw()
    game.draw()
    cute.draw(love.graphics)
end
function love.keypressed(key)
    game.keypressed(key)
    cute.keypressed(key)
end
function love.quit()
    game.quit()
end
