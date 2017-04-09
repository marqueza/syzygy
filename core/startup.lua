--graphic settings
--love.graphics.setNewFont(love.filesystem.getWorkingDirectory() .. "/res/font/Pixeled.ttf", 16)

if game.options.debug then
    if arg[#arg] == "-debug" then require("mobdebug").start() end
end
