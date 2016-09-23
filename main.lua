local state = require "lib.gamestate"

require 'action_state'
require 'inv_state'
require 'engine'

function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  love.window.setMode(1280,720)
  love.graphics.setFont(love.graphics.newFont('slkscr.ttf', 24))
  e = Engine()  
  state.registerEvents()
  state.switch(action_state)
end


function love.draw()
  e.screen:draw()
  --love.graphics.print(""..e.turn)
end

