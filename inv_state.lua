local state = require "lib.gamestate"
inv_state = {}

function inv_state:enter()
  e.screen:spawnInventory(e.player.inv)
end

function inv_state:update(dt)
  e.screen:update(dt)
 local item = e.screen.invMenu.choice
  if item then
    e.screen:sendMessage(item.name.." dropped.")
    
    --put item on floor
    e.player:dropItem(e.screen.invMenu.choiceIndex, e.dungeon:getZone())
    --now exit inv state
    
    state.switch(action_state)
   
  end
   
end

function inv_state:keypressed(key)
  e.screen.invMenu:keypressed(key)
  if key == 'escape' then
     state.switch(action_state)
  end
end

function inv_state:leave()
  e.screen.invMenu = nil
end

return inv_state