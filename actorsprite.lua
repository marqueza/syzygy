local anim8 = require "lib/anim8"
local class = require "lib/middleclass"
require "sprite"

ActorSprite = class("ActorSprite", Sprite)

function ActorSprite:initialize(filename, x, y, sheetX, sheetY)
  
   --init from parent
  Sprite:initialize(filename, x, y, sheetX, sheetY)
  
  --animations
  self.ani = {
    walkLeft = anim8.newAnimation(self.g(2,1, 2,1), 1),
    walkRight = anim8.newAnimation(self.g(2,1, 2,1), 1):flipH(),
    idleLeft = anim8.newAnimation(self.g(1,1, 1,1), 1),
    idleRight = anim8.newAnimation(self.g(1,1, 1,1), 1):flipH(),
  }
  
  --set up spritebatch
  self.curAni = self.ani.walkLeft
  self:initBatch()
  
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function ActorSprite:isMoving()
  return not (self.grid_x == round(self.actual_x) and self.grid_y == round(self.actual_y))
end


--changing gird x y coords
--allows the class to keep track of the actual x y coords
--and when to change animations and spritebatch
function ActorSprite:update(dt)
  
  --update location
  self.actual_y = self.actual_y - ((self.actual_y - self.grid_y) * self.speed * dt)
	self.actual_x = self.actual_x - ((self.actual_x - self.grid_x) * self.speed * dt)
  
  --choose animation based on movement status
  if self:isMoving() then
    if self.direction == 1 then
        self.curAni = self.ani.walkRight
      else
        self.curAni = self.ani.walkLeft
    end
  else
    if self.direction == 1 then
      self.curAni = self.ani.idleRight
    else
      self.curAni = self.ani.idleLeft
    end
  end
  
  --update animation
  self.curAni:update(dt)
  --update batch, with new frame from animation, and new location data
  --special case for player who is always centered
  if (self.sheetX == 1 and self.sheetY ==1) then
    self.batch:set(self.batchId, self.curAni:getFrameInfo(love.graphics.getWidth()/2, love.graphics.getHeight()/2)) 
  else
    self.batch:set(self.batchId, self.curAni:getFrameInfo(self.actual_x, self.actual_y))
  end
end

function Sprite:draw()
  love.graphics.draw(self.batch)
end

