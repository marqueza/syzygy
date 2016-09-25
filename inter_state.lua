local state = require "lib.gamestate"

inter_state = {}

function inter_state:enter()
  e.screen:spawnInteraction( {"ATTACK", "RECRUIT"} )
end

function inter_state:update(dt)
  e.screen:update(dt)
 local interaction = e.screen.interMenu.choice
  if interaction then
    
    --perform the interaction
    if interaction == "ATTACK" then
      
      e.screen:sendMessage("You robust the " .. e.target.name..".")
      e.player:attack(e.target)
      
      --exit state
      state.switch(action_state)
    elseif interaction == "RECRUIT" then
      e.screen:sendMessage("You recruit the " .. e.target.name..".")
      
      --exit state
      state.switch(action_state)
    end
  end
   
end

function inter_state:keypressed(key)
  e.screen.interMenu:keypressed(key)
  if key == 'escape' then
     state.switch(action_state)
  end
end

function inter_state:leave()
  e.screen.interMenu = nil
end

return inter_state