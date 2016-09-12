local class = require "lib/middleclass"

Enitity = class("Enitity")

--an enitity is an item, tile, or actor
--they have a grid position and sprite
function Enitity:initialize(name, x, y, imgName)
  
  self.name = name
  self.x = x
  self.y = y
end
