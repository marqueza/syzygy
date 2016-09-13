local class = require 'lib.middleclass'
local camera = require 'lib.hump.camera'
local timer = require 'lib.hump.timer'

require("lib/snes_gui")
require "mLayer"
Screen = class('mLayer')
  local boxWidth = 100
  local boxX = 150
  local boxY = 20
function Screen:initialize(mLayer)
  self.mLayer = mLayer
  self.camera = camera(mLayer.player.sprite.actual_x, mLayer.player.sprite.actual_y)
  self.pcam = camera(mLayer.player.sprite.actual_x, mLayer.player.sprite.actual_y)
  self.width = love.graphics.getWidth()
  self.height = love.graphics.getHeight()
  self.scale = 1

  --gui fields
  self.guiBackground={r=0, g=0, b=0, alpha=240}
  self.guiOutline={r=255, g=255, b=255, alpha=255, style="rough"}
  gui_stack.set_defaults("font/Pixeled.ttf", 15, self.guiBackground, self.guiOutline)
  
  --example notice box
  --local nText = "THIS IS AN EXAMPLE TEXT BOX"
  --gui_stack.add("notice",		notice_box(	10, 	2, 	220*2, 	65*2, 	gui_trans.open,	nText))

  
	-- This is message box. Unlike the notice box, it reacts automatically to player input
	-- closing and opening when a button is pushed.
	--				ID							X		Y		Width	Height	Transition		Text

 gui_stack.add("topMessage",		notice_box(boxX, 	boxY, 	220*2, 	120, 	gui_trans.open,	""))
  
  gui_stack.disable("topMessage")
  gui_stack.close("topMessage")
  gui_stack.stack["topMessage"].closed = true
  --gui_stack.enable("topMessage")
end

function Screen:update(dt)
  
  local sX, sY = math.floor(self.mLayer.player.sprite.actual_x), math.floor(self.mLayer.player.sprite.actual_y)
  self.camera:lockPosition(sX,sY)
  self.mLayer.player.sprite:setOverride(self.camera.x,self.camera.y)
  
  self.mLayer:update(dt)
  gui_stack.update()
  
  timer.update(dt)

end

function Screen:draw()
  self.camera:attach() 
  self.mLayer:draw()
  
  self.mLayer.player:draw()
  
  self.camera:detach()
  gui_stack.draw()	
end

function Screen:zoom(mult)
  --self.scale = self.scale*mult
  e.screen.camera:zoom(mult)
end

function Screen:sendMessage(text) 
  if (gui_stack.closed("topMessage") ) then
    gui_stack.open("topMessage")
    gui_stack.set_text("topMessage", text)
    timer.after(6, function() gui_stack.close("topMessage") end)

  else
    gui_stack.set_text("topMessage", text)
    timer.clear()
    timer.after(6, function() gui_stack.close("topMessage") end)
  end
end