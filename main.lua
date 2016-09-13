require 'engine'

function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  e = Engine()
end

function love.update(dt)
  e.screen:update(dt)
end

function love.draw()
  e.screen:draw()
end

  
function love.keypressed(key)
  
    if key == '-' then
      e.screen:zoom(.5)
    elseif key == '=' then
      e.screen:zoom(2)
    end
    
    
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

    e:movePlayer(dx,dy)
    
    if key == 'z' then
      e.screen:sendMessage( e.player:touchArea(e.zone) )
    end
end
