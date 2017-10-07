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
end
function StatusBoxSystem:draw()
  --love.graphics.rectangle("fill", 0, 0, game.options.topBarWidth, game.options.topBarHeight)
  if systems.levelSystem.currentLevelName then
    
    love.graphics.print(string.upper(systems.levelSystem.currentLevelName).."-"..
        systems.levelSystem.currentLevelDepth, 
        self.pixelX+self.marginWidth+500, self.pixelY+12)
  end
  if game.player then
    
    love.graphics.print(string.upper(game.player.name).."\nHP",
      self.pixelX+self.marginWidth, self.pixelY+12)
      local lifeRatio = game.player.Physics.hp / game.player.Physics.maxHp
      love.graphics.setColor(100,0,100,255)
      love.graphics.setColor(255,50,50,255)
      local barWidth = 120
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
