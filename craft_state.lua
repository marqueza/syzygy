local state = require "lib.gamestate"

craft_state = {}

function craft_state:enter()
  e.screen:spawnCrafting()
end

function craft_state:update(dt)
  e.screen:update(dt)
 local craft = e.screen.craftMenu.choice
  if craft then
    
    --perform the crafting
    if craft == "KEY GOLEM" then
      --zone spawn key golem
      e.dungeon:getZone():spawnMob(Actor("KEY GOLEM", 
        1,1, 
        3,3, 
        nil,
        'ally',
        nil) )
      state.switch(action_state)
      
      --teleport to player
      
      --perform check
      
      --remove items
      ---
      
      --make new item or creature
      ---
    end
  end
   
end

function craft_state:keypressed(key)
  e.screen.craftMenu:keypressed(key)
  if key == 'escape' then
     state.switch(action_state)
  end
end

function craft_state:leave()
  e.screen.craftMenu = nil
end

return craft_state