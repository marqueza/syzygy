local class = require "lib/middleclass"
require "enitity"
require "featuresprite"
Feature = class("Feature", Enitity)

--features are things in the dungeon can be interacted with
--such as buttons, doors, statues, etc
function Feature:initialize(name, x,y, sheetX,sheetY, isPassible, active)
  Enitity.initialize(self, name, x, y)
  self.sheetX = sheetX
  self.sheetY = sheetY
  self.sprite = FeatureSprite("img/tiles.png", 64*x, 64*y, sheetX or 1,sheetY or 1)
  
  --all features belong to a zone
  self.isPassible = isPassible or false
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

--a feature may do something on touch
function Feature:touch(zone)
  --current doors are the only features
  self:activate()
  zone.map[self.x][self.y] = 0
end

function Feature:activate()
  self.active = true
  self.sprite.curAni = self.sprite.ani.active
end
  