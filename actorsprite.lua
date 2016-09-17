local anim8 = require "lib/anim8"
local class = require "lib/middleclass"
require "sprite"

ActorSprite = class("ActorSprite", Sprite)

function ActorSprite:initialize(aniType, x, y, sheetX, sheetY, filename)
  
   --init from parent
  Sprite:initialize(filename, x, y, sheetX, sheetY)
  self.override = false
  
  --animations
  if aniType == "GOO" then
     self.ani = {
      idleLeft = anim8.newAnimation(self.g(sheetX, sheetY, sheetX+1, sheetY), 1),
      idleRight = anim8.newAnimation(self.g(sheetX, sheetY, sheetX+1, sheetY), 1):flipH(),
      walkLeft = anim8.newAnimation(self.g(sheetX+1, sheetY, sheetX+1, sheetY), 1),
      walkRight = anim8.newAnimation(self.g(sheetX+1, sheetY, sheetX+1, sheetY), 1):flipH()
    }
  else
    self.ani = {
      idleLeft = anim8.newAnimation(self.g(sheetX, sheetY, sheetX, sheetY), 1),
      idleRight = anim8.newAnimation(self.g(sheetX, sheetY, sheetX, sheetY), 1):flipH(),
      walkLeft = anim8.newAnimation(self.g(sheetX+1, sheetY, sheetX+1, sheetY), 1),
      walkRight = anim8.newAnimation(self.g(sheetX+1, sheetY, sheetX+1, sheetY), 1):flipH()
    }
  end
  
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
  if (self.override) then
    self.batch:set(self.batchId, self.curAni:getFrameInfo(self.ovX, self.ovY))
  else
    self.batch:set(self.batchId, self.curAni:getFrameInfo(self.actual_x, self.actual_y))
  end
end

function ActorSprite:setOverride(ovX,ovY)
  self.override = true
  self.ovX,self.ovY = ovX, ovY
end

function Sprite:draw()
  love.graphics.draw(self.batch)
end

