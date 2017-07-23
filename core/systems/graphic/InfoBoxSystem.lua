local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local InfoBoxSystem = class("InfoBoxSystem", lovetoys.System)

function InfoBoxSystem:initialize()
    lovetoys.System.initialize(self)
    self.pixelX = 700
    self.pixelY = 15
    self.text = nil
    self.examinee = nil
end
function InfoBoxSystem:draw()
    love.graphics.print(self.text or "BLANK\n",
    self.pixelX+0,
    self.pixelY+0)
end

--listen to focus events to update self.text
function InfoBoxSystem:onFocusNotify()
    local examinee = systems.targetSystem.focus
    if systems.targetSystem.focus then
        self.text = "FOCUS: " .. string.upper(examinee.name)
        self.text = self.text .."\nHP: " .. string.upper(examinee.Physics.hp) .. "/"..examinee.Physics.maxHp
        self.examinee = examinee
    end
end

function InfoBoxSystem:requires()
    return {}
end

function InfoBoxSystem:refreshInfoBox()
    if self.examinee then
        self.text = "FOCUS: " .. string.upper(self.examinee.name)
        self.text = self.text .."\nHP: " .. string.upper(self.examinee.Physics.hp) .. "/"..self.examinee.Physics.maxHp
    end
end

return InfoBoxSystem
