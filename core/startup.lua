--graphic settings
--love.graphics.setNewFont(love.filesystem.getWorkingDirectory() .. "/res/font/Pixeled.ttf", 16)
love.graphics.setNewFont("res/font/Pixeled.ttf", 10)

if config.debug then
    if arg[#arg] == "-debug" then require("mobdebug").start() end
end
love.window.setMode(1280,720)
