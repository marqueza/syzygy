local class = require "lib/middleclass"
require "sprite"

Enitity = class("Enitity")

--an enitity is an item, tile, or actor
--they have a grid position and sprite
function Enitity:initialize(x,y,name)
  self.x = x
  self.y = y
  self.name = name
  self.sprite = Sprite("img/" .. self.name .. ".png", 64*x, 64*y)
end
function Enitity:move(dx,dy)
  
end
function Enitity:teleport(x,y)

end