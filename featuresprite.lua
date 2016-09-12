local anim8 = require "lib/anim8"
local class = require "lib/middleclass"
require "sprite"

FeatureSprite = class("FeatureSprite", Sprite)

function FeatureSprite:initialize(filename, x, y, sheetX, sheetY)
  
   --init from parent
  Sprite.initialize(self, filename, x, y, sheetX, sheetY)
  
  --animations
  self.ani = {
   inert = anim8.newAnimation(self.g(sheetX,sheetY, sheetX,sheetY), 1),
   active = anim8.newAnimation(self.g(sheetX+1,sheetY, sheetX+1,sheetY), 1),
  }

  --set up spritebatch
  self.curAni = self.ani.inert
  self:initBatch()
end


function FeatureSprite:update(dt)
     
  --update animation
  self.curAni:update(dt)
  --update batch, with new frame from animation, and new location data
  self.batch:set(self.batchId, self.curAni:getFrameInfo(self.actual_x, self.actual_y)) --x,y,r,sx,sy,ox,oy,kx,ky


end