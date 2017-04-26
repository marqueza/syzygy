local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local InfoBoxSystem = class("InfoBoxSystem", lovetoys.System)

function InfoBoxSystem:initialize()
    lovetoys.System.initialize(self)
    self.pixelX = 700
    self.pixelY = 10
    self.text = nil
end
function InfoBoxSystem:draw()
    love.graphics.print(self.text or "BLANK",
    self.pixelX+0,
    self.pixelY+0)
end

--listen to focus events to update self.text
function InfoBoxSystem:onFocusNotify()
    self.text = "FOCUS: " .. string.upper(systems.targetSystem.focus.name)
end

function InfoBoxSystem:requires()
    return {}
end

return InfoBoxSystem
