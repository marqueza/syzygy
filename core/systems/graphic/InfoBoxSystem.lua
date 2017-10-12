local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local InfoBoxSystem = class("InfoBoxSystem", lovetoys.System)

function InfoBoxSystem:initialize()
    lovetoys.System.initialize(self)
    self.pixelX = 0
    self.pixelY = game.options.viewportHeight-100
    self.marginWidth = 10
    self.marginHeight = 10
    self.text = nil
    self.examinee = nil
    self.visible =  true
    self.font = love.graphics.setNewFont("res/font/PressStart/PressStart2p.ttf", 8)
end

_refreshText = function(self)
  --self.text = string.upper(self.examinee.name) .. "("..string.upper(self.examinee.id)..")"
  --self.text = self.text .."\nHP: " .. string.upper(self.examinee.Stats.hp) .. "/"..self.examinee.Stats.maxHp
  self.text = self.examinee:toString()
end
function InfoBoxSystem:draw()
  if self.visible then
    love.graphics.setColor(0,0,0,100)
    love.graphics.rectangle("fill", self.pixelX, self.pixelY, game.options.viewportWidth, 100)
    love.graphics.setColor(255,255,255,255)
    love.graphics.setFont(self.font)
    love.graphics.print(self.text or "",
    self.pixelX+self.marginWidth,
    self.pixelY+self.marginHeight)
  love.graphics.setFont(game.options.font)
  end
end

--listen to focus events to update self.text
function InfoBoxSystem:onFocusNotify()
    local examinee = systems.targetSystem.focus
    if examinee and systems.targetSystem.focus then
      self.examinee = examinee
      _refreshText(self)
    end
end

function InfoBoxSystem:requires()
    return {}
end

function InfoBoxSystem:refreshInfoBox()
    if self.examinee then
      _refreshText(self)
    end
end

return InfoBoxSystem
