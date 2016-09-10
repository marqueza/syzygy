local class = require "lib/middleclass"
require "sprite"

Enitity = class("Enitity")

--an enitity is an item, tile, or actor
--they have a grid position and sprite
function Enitity:initialize(x,y,name, imgName)
  self.x = x
  self.y = y
  self.name = name
end
