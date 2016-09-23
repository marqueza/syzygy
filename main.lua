local Gamestate = require "lib.gamestate"
require 'engine'

local invState = {}
local localState = {}

function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  love.window.setMode(1280,720)
  love.graphics.setFont(love.graphics.newFont('slkscr.ttf', 24))
  e = Engine()
  
  Gamestate.registerEvents()
  Gamestate.switch(localState)
end

function localState:update(dt)
  e.screen:update(dt)
  if e.turn ==2 then
    e.dungeon:getZone():invokeMobs()
    e:nextTurn()
  end
end

function love.draw()
  e.screen:draw()
end

function localState:keypressed(key)

  --player controls
  if e.turn == 1 then 
    local dx,dy = 0,0
    if     key=='kp1' then dx,dy=-1, 1
    elseif key=='kp2' then dx,dy= 0, 1
    elseif key=='kp3' then dx,dy= 1, 1
    elseif key=='kp4' then dx,dy=-1, 0
    elseif key=='kp5' then dx,dy= 0, 0
    elseif key=='kp6' then dx,dy= 1, 0
    elseif key=='kp7' then dx,dy=-1,-1
    elseif key=='kp8' then dx,dy= 0,-1
    elseif key=='kp9' then dx,dy= 1,-1
    end
    e.player:move(dx,dy, e.dungeon:getZone())
    e:nextTurn()
    
    if key == 'z' then
      e.player:touchArea(e.dungeon:getZone())
      e:nextTurn()
    elseif key == 'g' then
      e.player:grabFloor(e.dungeon:getZone())
      e:nextTurn()
    end
  end
  
--system level
  if key == '-' then
    e.screen:zoom(.5)
  elseif key == '=' then
    e.screen:zoom(2)
  elseif key == 'q' then
    e:quit()
  elseif key == 'l' then
    e:loadGame()
  elseif key == 'r' then
    e:restart()
  elseif key == 's' then
    e:save()
  elseif key == '.' then
    e:downZone()
  elseif key == ',' then
    e:upZone()
  elseif key == 'd' then
    e.screen:sendMessage("Drop which item? ")
    Gamestate.switch(invState)
  end

end

function invState:enter()
  e.screen:spawnInventory(e.player.inv)
end

function invState:update(dt)
  e.screen:update(dt)
 local item = e.screen.invMenu.item
  if item then
    e.screen:sendMessage(item.name.." dropped.")
    
    --put item on floor
    e.player:dropItem(e.screen.invMenu.itemIndex, e.dungeon:getZone())
    --now exit inv state
    
    Gamestate.switch(localState)
   
  end
   
end

function invState:keypressed(key)
  e.screen.invMenu:keypressed(key)
  if key == 'escape' then
     Gamestate.switch(localState)
  end
end

function invState:leave()
  e.screen.invMenu = nil
end