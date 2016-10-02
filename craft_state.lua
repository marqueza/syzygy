local state = require "lib.gamestate"
local recipes = require 'recipes'


craft_state = {}

function craft_state:enter()
  e.screen:spawnCrafting()
end

function craft_state:update(dt)
  e.screen:update(dt)
  local craft = e.screen.craftMenu.choice
  local craftIndex = e.screen.craftMenu.choiceIndex
  
  if craft then
    -- 
    --a selection was made, attempt crafting
    --
    
      --get the list of ings with amounts
      local ingList = recipes[craftIndex].ingredients
        
      local dupList = {}
      --get the list of player inv with amounts
      for i,object in ipairs(e.player.inv) do
        local text = object.name
        if not dupList[text] then
          dupList[text] = 1
        else
          dupList[text] = dupList[text] + 1
        end
      end
        
      local canCraft = true
      --check if all ings are in inventory
      for i, ing in ipairs(ingList) do
        if not dupList[ing.name] then
          canCraft = false
        elseif not (dupList[ing.name] >= ing.amount) then
          canCraft = false
        end
      end
        
      if canCraft then
        --zone spawn key golem
        local mob = Actor(craft)
        mob.x = e.player.x
        mob.y = e.player.y
        mob.faction = 'ally'
        
        e.dungeon:getZone():spawnMob(mob)
        e.screen:sendMessage("A "..craft.." HAS BEEN FORMED. ")
        state.switch(action_state)
        
        --expend items used
        local indexesToRemove = {}
        for itemName, remaining in pairs(dupList) do
          for i, item in ipairs(e.player.inv) do
            if itemName == item.name and remaining > 0 then
              table.insert(indexesToRemove, i)
            end
          end
        end
        for i, indexToRemove in ipairs(indexesToRemove) do
          table.remove(e.player.inv, indexToRemove)
        end
      else
        e.screen:sendMessage("NOT ENOUGH INGREDIENTS. ")
        state.switch(action_state)
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