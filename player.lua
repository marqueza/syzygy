local class = require "lib/middleclass"
require "actor"

Player = class("Player", Actor)

function Player:initialize(args)
  if args == nil then
    args = {}
    args.name = "player"
    args.faction = "ally"
    args.sheetX = 1
    args.sheetY = 4
    args.hp = 40
  end
    Actor.initialize(self, args)--invoke parent class Actor
end

function Player:move(dx,dy,zone)
  Actor.move(self, dx, dy, zone)
  zone:updateFov(self.x, self.y)
end

--
--must be updated or deprecated, when targeting commands are written
--
function Player:getAdjMob(zone)  
    for i, mob in ipairs(zone.mobs) do
      if ((mob.x == self.x or mob.x == self.x+1 or mob.x == self.x-1) and 
          (mob.y == self.y or mob.y == self.y+1 or mob.y == self.y-1) ) then
        return mob
      end
    end
end

function Player:grabFloorItem(zone)
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



function Player:recruit(target)
  target.faction = 'ally'
  target.hp = 40
end

function Player:attack(target)
  Actor.attack(self, target)
end
function Player:die()
  e:loadGame()
end