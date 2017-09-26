local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local InfoBoxSystem = class("InfoBoxSystem", lovetoys.System)

function InfoBoxSystem:initialize()
    lovetoys.System.initialize(self)
    self.pixelX = game.options.viewportWidth
    self.pixelY = game.options.viewportHeight-200
    self.marginWidth = 10
    self.marginHeight = 10
    self.text = nil
    self.examinee = nil
    self.visible = false
end

_refreshText = function(self)
  self.text = string.upper(self.examinee.name) .. "("..string.upper(self.examinee.id)..")"
  self.text = self.text .."\nHP: " .. string.upper(self.examinee.Physics.hp) .. "/"..self.examinee.Physics.maxHp
  self.text = self.examinee:toString()
end
function InfoBoxSystem:draw()
  if self.visible then
    love.graphics.print(self.text or "",
    self.pixelX+self.marginWidth,
    self.pixelY+self.marginHeight)
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
