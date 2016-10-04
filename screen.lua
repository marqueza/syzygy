local class = require 'lib.middleclass'
local camera = require 'lib.camera'
local timer = require 'lib.timer'
local UI = require 'lib.UI'
local term = require 'term'
require "menu"
require "craftMenu"
require "mLayer"
Screen = class('mLayer')

function Screen:initialize(mLayer)
  local displayWidth = love.graphics.getWidth()
  local displayHeight = love.graphics.getHeight()
  
  self.mLayer = mLayer
  self.camera = camera(mLayer.player.sprite.actual_x, mLayer.player.sprite.actual_y)
  self.width = love.graphics.getWidth()
  self.height = love.graphics.getHeight()
  self.scale = 1
  
 -- love.graphics.setBackgroundColor(20,20,20)
  self.bgImg = love.graphics.newImage('img/stars.png')
  self.bgImg:setWrap('mirroredrepeat', 'mirroredrepeat')
  self.bgQuad = love.graphics.newQuad(0,0, self.width*4,self.height*2, self.bgImg:getDimensions())
  self.bgCamera = camera(self.width/2,self.height/2)
  UI.registerEvents()
  
  local boxHeight = 24*8
  
  self.term= term(0, displayHeight-boxHeight, displayWidth, boxHeight)
  
  self.yellow = 250
  self.direction = 1
  
end

function Screen:update(dt)
  
  local offsetY = 64
  local offsetX = 64/2
  local sX, sY = math.floor(self.mLayer.player.sprite.actual_x), math.floor(self.mLayer.player.sprite.actual_y)
  self.camera:lockPosition(sX+offsetX,sY+offsetY)
  self.mLayer.player.sprite:setOverride(self.camera.x-offsetX,self.camera.y-offsetY)
  
  self.mLayer:update(dt)
  
  timer.update(dt)
  
  self.term:update(dt)
  if self.invMenu then self.invMenu:update(dt) end
  if self.interMenu then self.interMenu:update(dt) end
  if self.craftMenu then self.craftMenu:update(dt) end
  
  if self.bgCamera.x+self.width/2 > self.width*4 then
    self.bgCamera.x = self.bgCamera.x-self.width*3
  end
  self.bgCamera:move(.2,.1)
  self.yellow = (self.yellow+.1*self.direction) 
  if self.yellow >= 255 or self.yellow < 60 then
    self.direction = self.direction * -1
  end
end


function Screen:draw()
  
  self.bgCamera:attach() 
  love.graphics.setColor(255,255,self.yellow,255)
  love.graphics.draw(self.bgImg, self.bgQuad)
  
  self.bgCamera:detach()
  love.graphics.setColor(255,255,255,20)
  love.graphics.rectangle( 'fill', 0, 0, self.width, self.height)
  love.graphics.setColor(255,255,255,255)
  
  self.camera:attach() 
  self.mLayer:draw()
  
  self.mLayer.player:draw()
  
  self.camera:detach()
  
  
  self.term:draw()
  if self.invMenu then self.invMenu:draw() end
  if self.interMenu then self.interMenu:draw() end
  if self.craftMenu then self.craftMenu:draw() end
  love.graphics.setColor(255,255,255,255)
  
 -- love.graphics.print("bgX "..self.bgCamera.x.." bgY "..self.bgCamera.x, 0, 30)
end

function Screen:zoom(mult)
  e.screen.camera:zoom(mult)
end

function Screen:sendMessage(text) 
  self.term:sendMessage(text)
end

function Screen:spawnInventory(invTable)
  self.invMenu = Menu(0, 0, invTable)
end

function Screen:spawnInteraction(interTable)
  self.interMenu = Menu(0, 0, interTable)
end

function Screen:spawnCrafting()
  self.craftMenu = CraftMenu(0, 0)
end
