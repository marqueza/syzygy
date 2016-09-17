local class = require "lib/middleclass"
require "actor"

Player = class("Player", Actor)

function Player:initialize(x, y, inv, sheetX, sheetY)
  Actor.initialize(self, "PLAYER", x or 1, y or 1, sheetX, sheetY)--invoke parent class Actor
  self.inv = inv or {}
end

function Player:touchArea(zone)
  
    --interact with surroundings
    for i,item in ipairs(zone.items) do

      --if player found an item
      if ((item.x == self.x or item.x == self.x+1 or item.x == self.x-1) and (item.y == self.y or item.y == self.y+1 or item.y == self.y-1) ) then
        
        --pick up item from floor
        table.insert(self.inv, item)
        item.onFloor = false
        table.remove(zone.items, i)
        
        return "ACQUIRED "..item.name.."."
      end
      
    end
    return "NOTHING HAPPEND"
end