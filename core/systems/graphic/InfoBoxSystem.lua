local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local InfoBoxSystem = class("InfoBoxSystem", lovetoys.System)

function InfoBoxSystem:initialize()
    lovetoys.System.initialize(self)
    self.pixelX = game.options.viewportWidth
    self.pixelY = game.options.viewportHeight/5
    self.marginWidth = 35
    self.text = nil
    self.examinee = nil
end
function InfoBoxSystem:draw()
    love.graphics.print(self.text or "BLANK\n",
    self.pixelX+self.marginWidth,
    self.pixelY)
end

--listen to focus events to update self.text
function InfoBoxSystem:onFocusNotify()
    local examinee = systems.targetSystem.focus
    if examinee and systems.targetSystem.focus then
        self.text = "FOCUS: " .. string.upper(examinee.name) .. "("..examinee.id..")"
        self.text = self.text .."\nHP: " .. string.upper(examinee.Physics.hp) .. "/"..examinee.Physics.maxHp
        self.examinee = examinee
    end
end

function InfoBoxSystem:requires()
    return {}
end

function InfoBoxSystem:refreshInfoBox()
    if self.examinee then
        self.text = "FOCUS: " .. string.upper(self.examinee.name) .. "("..self.examinee.id..")"
        self.text = self.text .."\nHP: " .. string.upper(self.examinee.Physics.hp) .. "/"..self.examinee.Physics.maxHp
    end
end

return InfoBoxSystem
