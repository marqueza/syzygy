local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local StatusBoxSystem = class("StatusBoxSystem", lovetoys.System)

function StatusBoxSystem:initialize()
    lovetoys.System.initialize(self)
    self.pixelX = 0
    self.pixelY = -5
    self.marginWidth = 10
    self.text = nil
    self.examinee = nil
    self.nameWidth = 200
    self.statWidth = 600
end
function StatusBoxSystem:draw()
  love.graphics.setColor(0,0,0,255)
  love.graphics.rectangle("fill", 0, 0, game.options.topBarWidth, game.options.topBarHeight)
  love.graphics.setColor(255,255,255,255)
  if game.player and game.player.Physics.plane then
    
    love.graphics.print(string.upper(game.player.Physics.plane), 
        self.pixelX+self.marginWidth+self.nameWidth+self.statWidth, self.pixelY+12)
  end
  local examinee = systems.targetSystem.focus or game.player
  if examinee and examinee.Stats then
    love.graphics.print(string.upper(examinee.name) .. "\nHP", self.pixelX+self.marginWidth, self.pixelY+12)
      local lifeRatio = examinee.Stats.hp / examinee.Stats.maxHp
      love.graphics.setColor(100,0,100,255)
      love.graphics.setColor(255,50,50,255)
      local barWidth = 90
      local barPixelX = 60
      local barPixelY = 1+20
      local barHeight = 13
      love.graphics.rectangle( "fill", 
        barPixelX, 
        barPixelY, 
        barWidth*lifeRatio, 
        barHeight
      )
      love.graphics.setColor(255,200,200,255)
      love.graphics.rectangle( "fill", 
        barPixelX + barWidth*lifeRatio, 
        barPixelY, 
        barWidth*(1-lifeRatio), 
        barHeight
      )
      love.graphics.setColor(255,255,255,255)
      love.graphics.print(string.upper(
          "LV:"..systems.expSystem:getLevel(examinee)..
          " EP:" .. examinee.Stats.exp..
          "  ST:" .. examinee.Stats.str..
          " DX:" .. examinee.Stats.str..
          " CN:" .. examinee.Stats.str..
          " WS:" .. examinee.Stats.str .. "   ")
        
        , self.pixelX+self.marginWidth+self.nameWidth, self.pixelY+12 )
      
      
      love.graphics.setColor(255,255,255,255)
      
  end
end

--listen to focus events to update self.text
function StatusBoxSystem:onFocusNotify()
end

function StatusBoxSystem:requires()
    return {}
end

function StatusBoxSystem:refreshInfoBox()
end

return StatusBoxSystem
