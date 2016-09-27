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
  self.pcam = camera(mLayer.player.sprite.actual_x, mLayer.player.sprite.actual_y)
  self.width = love.graphics.getWidth()
  self.height = love.graphics.getHeight()
  self.scale = 1

 
  UI.registerEvents()
  
  local boxHeight = 24*8
  
  self.term= term(0, displayHeight-boxHeight, displayWidth, boxHeight)
  
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

end


function Screen:draw()
  self.camera:attach() 
  self.mLayer:draw()
  
  self.mLayer.player:draw()
  
  self.camera:detach()
  self.term:draw()
  if self.invMenu then self.invMenu:draw() end
  if self.interMenu then self.interMenu:draw() end
  if self.craftMenu then self.craftMenu:draw() end
  love.graphics.setColor(255,255,255,255)
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
