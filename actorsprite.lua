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
      walkLeft = {
        anim8.newAnimation(self.g(sheetX+1, sheetY, sheetX+1, sheetY), 1),
        anim8.newAnimation(self.g(sheetX+1, sheetY, sheetX+1, sheetY), 1)
        },
      walkRight = {
        anim8.newAnimation(self.g(sheetX+1, sheetY, sheetX+1, sheetY), 1):flipH(),
        anim8.newAnimation(self.g(sheetX+1, sheetY, sheetX+1, sheetY), 1):flipH()
        },
    }
  else
    self.ani = {
      idleLeft = anim8.newAnimation(self.g(sheetX, sheetY, sheetX, sheetY), 1),
      idleRight = anim8.newAnimation(self.g(sheetX, sheetY, sheetX, sheetY), 1):flipH(),
      walkLeft = {anim8.newAnimation(self.g(sheetX+1, sheetY, sheetX+1, sheetY), .1), 
                  anim8.newAnimation(self.g(sheetX+2, sheetY, sheetX+2, sheetY), .1)},
      walkRight = {
        anim8.newAnimation(self.g(sheetX+1, sheetY, sheetX+1, sheetY), .1):flipH(),
        anim8.newAnimation(self.g(sheetX+2, sheetY, sheetX+2, sheetY), .1):flipH(), 
                  },
    }
  end
  self.foot = 1
  self.wasMoving = false
  self.lastMapX, self.lastMapY = self:mapLocation()
  
  --set up spritebatch
  self.curAni = self.ani.idleLeft
  self:initBatch()
  
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function ActorSprite:isMoving()
  return not (self.grid_x == round(self.actual_x, 1) and self.grid_y == round(self.actual_y))
end

function ActorSprite:mapLocation()
  return math.floor(self.actual_x/64), math.floor(self.actual_y/64)
end


--changing gird x y coords
--allows the class to keep track of the actual x y coords
--and when to change animations and spritebatch
function ActorSprite:update(dt)
  
  --update location
  self.actual_y = self.actual_y - ((self.actual_y - self.grid_y) * self.speed * dt)
	self.actual_x = self.actual_x - ((self.actual_x - self.grid_x) * self.speed * dt)
  
  local mX, mY = self:mapLocation()
  if mX ~= self.lastMapX or mY ~= self.lastMapY then
    self.lastMapX = mX
    self.lastMapY = mY
    if self.foot == 1 then 
        self.foot = 2
    else 
        self.foot = 1 
    end
  end
  
  --choose animation based on movement status
  if self:isMoving() then
     if self.wasMoving == false then
     
      self.wasMoving = true
    end
    
    if self.direction == 1 then
        self.curAni = self.ani.walkRight[self.foot]
      else
        self.curAni = self.ani.walkLeft[self.foot]
    end
    
   
    
    
  else
    
    self.wasMoving = false
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

