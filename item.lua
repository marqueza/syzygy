local class = require "lib/middleclass"
require "itemsprite"
Item = class("Item", Enitity)


--an enitity is an item, tile, or actor
--they have a grid position and sprite
function Item:initialize(name, x,y, sheetX,sheetY, onFloor)
  Enitity.initialize(self, name, x, y)
  self.sheetX = sheetX
  self.sheetY = sheetY
  self.sprite = ItemSprite("img/item.png", 64*x, 64*y, sheetX or 1,sheetY or 1)
  self:place(x,y)

  self.onFloor = onFloor or true
end

function Item:place(x,y)
  self.x = x
  self.y = y
  self.sprite.actual_x = x*64
  self.sprite.actual_y = y*64
  self.sprite.grid_x = x*64
  self.sprite.grid_y = y*64
end
function Item:draw()
  if self.onFloor then 
    self.sprite:draw()
  end
end

function Item:update(dt)
  self.sprite:update(dt)
end