local anim8 = require "lib/anim8"
local class = require "lib/middleclass"
require "sprite"

ItemSprite = class("ItemSprite", Sprite)

function ItemSprite:initialize(filename, x, y, sheetX, sheetY)
  
  --init from parent
  Sprite:initialize(filename, x, y, sheetX, sheetY)
  
  --animations
  self.ani = {
   idle = anim8.newAnimation(self.g(sheetX,sheetY, sheetX+1,sheetY), 0.6)
  }
  
  --set up spritebatch
  self.curAni = self.ani.idle
  self:initBatch()
end

--changing gird x y coords
--allows the class to keep track of the actual x y coords
--and when to change animations and spritebatch
function ItemSprite:update(dt)
  
  --place any change in current animation here
  -- <--
  
  --update animation
  self.curAni:update(dt)
  --update batch, with new frame from animation, and new location data
  self.batch:set(self.batchId, self.curAni:getFrameInfo(self.actual_x, self.actual_y)) --x,y,r,sx,sy,ox,oy,kx,ky


end