local class = require "lib/middleclass"
require "enitity"
require "featuresprite"
Feature = class("Feature", Enitity)

--features are things in the dungeon can be interacted with
--such as buttons, doors, statues, etc
function Feature:initialize(name, x,y, sheetX,sheetY, zone)
  Enitity.initialize(self, name, x, y)
  self.sprite = FeatureSprite("img/tiles.png", 64*x, 64*y, sheetX or 1,sheetY or 1)
  
  --all features belong to a zone
  self.zone = zone
  self.isPassible = false
  self.active = false
end
function Feature:draw()
  self.sprite:draw()
end
function Feature:update(dt)
  self.sprite:update(dt)
end

--a feature may do something on touch
function Feature:touch()
  --current doors are the only features
  self:activate()
  self.zone.map[self.x][self.y] = 0
end

function Feature:activate()
  self.active = true
  self.sprite.curAni = self.sprite.ani.active
end
  