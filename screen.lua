local class = require 'lib.middleclass'
local camera = require 'lib.camera'
local timer = require 'lib.timer'
local UI = require 'lib.UI'
local term = require 'term'
local InvMenu = require 'invMenu'
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
  
  local boxHeight = displayHeight/5
  
  self.term= term(0, displayHeight-boxHeight, displayWidth, boxHeight)
  
  self.invMenu = InvMenu(displayWidth/2-400/2, 0, 400, 400, {"Milk", "Cheese", "Eggs", "Onions"})
end

function Screen:update(dt)
  
  local sX, sY = math.floor(self.mLayer.player.sprite.actual_x), math.floor(self.mLayer.player.sprite.actual_y)
  self.camera:lockPosition(sX,sY)
  self.mLayer.player.sprite:setOverride(self.camera.x,self.camera.y)
  
  self.mLayer:update(dt)
  
  timer.update(dt)

end

function Screen:draw()
  self.camera:attach() 
  self.mLayer:draw()
  
  self.mLayer.player:draw()
  
  self.camera:detach()
  self.term:draw()
  self.invMenu:draw()
  love.graphics.setColor(255,255,255,255)
end

function Screen:zoom(mult)
  --self.scale = self.scale*mult
  e.screen.camera:zoom(mult)
end

function Screen:sendMessage(text) 
end