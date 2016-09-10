local anim8 = require "lib/anim8"
local class = require "lib/middleclass"

ActorSprite = class("ActorSprite")

--
function ActorSprite:initialize(filename, x, y )
  --local variables needed for return values
  local img = love.graphics.newImage(filename)
  img:setFilter('nearest')
  local imgWidth,imgHeight = img:getDimensions()
  self.charSize = 64
  local g = anim8.newGrid(self.charSize,self.charSize, imgWidth,imgHeight)

  --
  --fields that will be needed by others
  --
  
  --info for needed for drawing/movement
  self.grid_x = x or 1
  self.grid_y = y or 1
  self.actual_x = x or 1
  self.actual_y = y or 1
  self.speed = 10 --default
  self.direction = -1 -- left, by default

  --pulls from grid based on image
  self.ani = {
    walkLeft = anim8.newAnimation(g(2,1, 2,1), 1),
    walkRight = anim8.newAnimation(g(2,1, 2,1), 1):flipH(),
    idleLeft = anim8.newAnimation(g(1,1, 1,1), 1),
    idleRight = anim8.newAnimation(g(1,1, 1,1), 1):flipH(),
  }

  --important for drawing
  self.curAni = self.ani.idleLeft
  self.batch = love.graphics.newSpriteBatch(img)
  self.batchId = self.batch:add(self.curAni:getFrameInfo(self.actual_x, self.actual_y))
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function ActorSprite:isMoving()
  return not (self.grid_x == round(self.actual_x) and self.grid_y == round(self.actual_y))
end


function ActorSprite:draw()
  love.graphics.draw(self.batch)
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
  self.batch:set(self.batchId, self.curAni:getFrameInfo(self.actual_x, self.actual_y)) --x,y,r,sx,sy,ox,oy,kx,ky

end