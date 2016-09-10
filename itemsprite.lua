local anim8 = require "lib/anim8"
local class = require "lib/middleclass"

ItemSprite = class("ItemSprite")

--
function ItemSprite:initialize(filename, x, y, sheetX, sheetY)
  --local variables needed for return values
  local img = love.graphics.newImage(filename)
  img:setFilter('nearest')
  local imgWidth,imgHeight = img:getDimensions()
  self.charSize = 64

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
  
  self.sheetX = sheetX
  self.sheetY = sheetY

  --pulls from grid based on image
  local g = anim8.newGrid(self.charSize,self.charSize, imgWidth,imgHeight)
  self.ani = {
   idle = anim8.newAnimation(g(sheetX,sheetY, sheetX+1,sheetY), 0.6)
  }

  --important for drawing
  self.curAni = self.ani.idle
  self.batch = love.graphics.newSpriteBatch(img)
  self.batchId = self.batch:add(self.curAni:getFrameInfo(self.actual_x, self.actual_y))
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end


function ItemSprite:draw()
  love.graphics.draw(self.batch)
end

--changing gird x y coords
--allows the class to keep track of the actual x y coords
--and when to change animations and spritebatch
function ItemSprite:update(dt)
  
  --place any change in current animation here
  -- <--
  
  --update current animation
  self.curAni:update(dt)
  --update batch, with new frame from animation, and new location data
  self.batch:set(self.batchId, self.curAni:getFrameInfo(self.actual_x, self.actual_y)) --x,y,r,sx,sy,ox,oy,kx,ky

end