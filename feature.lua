local class = require "lib/middleclass"
require "enitity"
require "featuresprite"

Feature = class("Feature", Enitity)

--features are things in the dungeon can be interacted with
--such as buttons, doors, statues, etc
function Feature:initialize(name, x,y, sheetX,sheetY, isPassable, active)
  Enitity.initialize(self,name, x, y)
  self.sheetX = sheetX
  self.sheetY = sheetY
  self.sprite = FeatureSprite("img/tiles.png", 64*x, 64*y, sheetX or 1,sheetY or 1)
  
  --all features belong to a zone
  self.isPassable = isPassable or false
  self.active = active or false
  
  if (self.active) then
    self.sprite.curAni = self.sprite.ani.active
  end
end
  
function Feature:draw()
  self.sprite:draw()
end

function Feature:update(dt)
  self.sprite:update(dt)
end

--a feature may do something on a passive bump
function Feature:bump(zone)
  if self.name == "DOOR" then
    self:activate()
    zone.map[self.x][self.y] = 0
  end
end
function Feature:touch(zone)
  if self.name == "DOOR" then
    self:activate()
    zone.map[self.x][self.y] = 0
  end
  
  if self.name == "GLASS GATE" then
    --self:activate()
    e.screen:sendMessage("YOU ESCAPED THE GREY ZONE!")
  end
end

function Feature:activate()
  self.active = true
  self.sprite.curAni = self.sprite.ani.active
  self.isPassable = true
end
function Feature:place(x,y)
  self.x = x
  self.y = y
  self.sprite.actual_x = x*64
  self.sprite.actual_y = y*64
  self.sprite.grid_x = x*64
  self.sprite.grid_y = y*64
end
  