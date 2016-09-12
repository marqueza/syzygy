local anim8 = require "lib/anim8"
local class = require "lib/middleclass"

Sprite = class("Sprite")

function Sprite:initialize(filename, x, y, sheetX, sheetY)
  self.img = love.graphics.newImage(filename)
  self.img:setFilter('nearest')
  self.imgWidth, self.imgHeight = self.img:getDimensions()
  self.charSize = 64
  self.grid_x = x or 1
  self.grid_y = y or 1
  self.actual_x = x or 1
  self.actual_y = y or 1
  self.speed = 10 
  self.direction = -1 -- left
  self.sheetX = sheetX
  self.sheetY = sheetY
  
  
  --pulls from grid based on image
  self.g = anim8.newGrid(self.charSize,self.charSize, self.imgWidth, self.imgHeight)
  
  --default curAni, should be replaced by child
  self.curAni = anim8.newAnimation(self.g(sheetX,sheetY, sheetX,sheetY), 1)
  
  ---
  --curAni needs to be set in the extened classes
  ---
end

function Sprite:initBatch()
  self.batch = love.graphics.newSpriteBatch(self.img)
  self.batchId = self.batch:add(self.curAni:getFrameInfo(self.actual_x, self.actual_y))
end

function Sprite:draw()
  love.graphics.draw(self.batch)
end
