local class = require "lib/middleclass"
require "actor"

Player = class("Player", Actor)

function Player:initialize(x, y, inv, sheetX, sheetY)
  Actor.initialize(self, "PLAYER", x or 1, y or 1, sheetX, sheetY, nil, 'ally')--invoke parent class Actor
end

function Player:move(dx,dy,zone)
  Actor.move(self, dx, dy, zone)
  zone:updateFov(self.x, self.y)
end

function Player:touchArea(zone)
    
    for i, feat in ipairs(zone.feats) do
      if ((feat.x == self.x or feat.x == self.x+1 or feat.x == self.x-1) and (feat.y == self.y or feat.y == self.y+1 or feat.y == self.y-1) ) then
        feat:touch(zone)
        return
      end
    end
    
end


function Player:getAdjMob(zone)
  
    for i, mob in ipairs(zone.mobs) do
      if ((mob.x == self.x or mob.x == self.x+1 or mob.x == self.x-1) and 
          (mob.y == self.y or mob.y == self.y+1 or mob.y == self.y-1) ) then
        return mob
      end
    end
end
function Player:grabFloor(zone)
  
    --interact with items
    for i,item in ipairs(zone.items) do
      if (item.x == self.x and item.y == self.y ) then
        --pick up item from floor
        table.insert(self.inv, item)
        item.onFloor = false
        table.remove(zone.items, i)
        e.screen:sendMessage("ACQUIRED "..item.name..".")
        return 
      end
    end

end


function Player:attack(target)
  target:die()
end

function Player:recruit(target)
  target.faction = 'ally'
end