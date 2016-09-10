local class = require 'lib.middleclass'
local Camera = require 'lib.hump.camera'
require "mLayer"
Screen = class('mLayer')
  
function Screen:initialize(mLayer)
self.mLayer = mLayer
self.camera = Camera(mLayer.player.sprite.grid_x, mLayer.player.sprite.grid_y)
self.width = love.graphics.getWidth()
self.height = love.graphics.getHeight()
end

function Screen:update(dt)
  local sX, sY = self.mLayer.player.sprite.grid_x, self.mLayer.player.sprite.grid_y
  local cX, cY = self.camera:cameraCoords(sX, sY)
  
  if cX >= self.width-128 or cX <= 128 then
    self.camera.x = sX
  end
  if cY >= self.height-128 or cY <=128 then
    self.camera.y = sY
  end
  if love.keyboard.isDown('c') then
    self.camera:lockPosition(sX,sY)
  end
  
  self.mLayer:update(dt)
end

function Screen:draw()
  self.camera:attach() 
  self.mLayer:draw()
  self.camera:detach()
end