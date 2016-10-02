local state = require "lib.gamestate"
require "inter_state"
require "inv_state"
require "craft_state"
action_state = {}

function action_state:update(dt)
  e.screen:update(dt)
  if e.turn ==1 then
    e.dungeon:getZone():invokeMobs()
    e:nextTurn()
  end
end

function action_state:keypressed(key)

  --player controls
  if e.turn == 0 then 
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
    if dx ~= 0 or dy ~= 0 then
      e.player:move(dx,dy, e.dungeon:getZone())
      e:nextTurn()
    end
    
    if key == 'm' then
      e.player:touchArea(e.dungeon:getZone())
      e:nextTurn()
    elseif key == 'g' then
      e.player:grabFloorItem(e.dungeon:getZone())
      e:nextTurn()
    elseif key == 'd' then
      e.screen:sendMessage("Drop which item? ")
      state.switch(inv_state)
      e:nextTurn()
    elseif key == 'c' then
      e.screen:sendMessage("Select recipe to craft. ")
      state.switch(craft_state)
      e:nextTurn()
    elseif key == 'z' then
      local mob = e.player:getAdjMob(e.dungeon:getZone())
      if mob then 
        e.screen:sendMessage("Do what to ".. mob.name .."? ")
        e.target = mob
        state.switch(inter_state)
        e:nextTurn()
      end
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
  end
  
end

return action_state