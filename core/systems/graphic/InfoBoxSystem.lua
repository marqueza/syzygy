local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local InfoBoxSystem = class("InfoBoxSystem", lovetoys.System)

function InfoBoxSystem:initialize()
    lovetoys.System.initialize(self)
    self.pixelX = game.options.viewportWidth-300
    self.pixelY = game.options.viewportHeight-300
    self.marginWidth = game.options.sideBarMarginWidth
    self.marginHeight = 10
    self.text = nil
    self.examinee = nil
end
function InfoBoxSystem:draw()
    love.graphics.print(self.text or "BLANK\n",
    self.pixelX+self.marginWidth,
    self.pixelY+self.marginHeight)
end

--listen to focus events to update self.text
function InfoBoxSystem:onFocusNotify()
    local examinee = systems.targetSystem.focus
    if examinee and systems.targetSystem.focus then
      self.examinee = examinee
      --[[
        self.text = "FOCUS: " .. string.upper(examinee.name) .. "("..examinee.id..")"
        self.text = self.text .."\nHP: " .. string.upper(examinee.Physics.hp) .. "/"..examinee.Physics.maxHp
        self.examinee = examinee
        --]]
        self.text = self.examinee:toString()
    end
end

function InfoBoxSystem:requires()
    return {}
end

function InfoBoxSystem:refreshInfoBox()
    if self.examinee then
      --[[
        self.text = "FOCUS: " .. string.upper(self.examinee.name) .. "("..self.examinee.id..")"
        self.text = self.text .."\nHP: " .. string.upper(self.examinee.Physics.hp) .. "/"..self.examinee.Physics.maxHp
        --]]
        self.text = self.examinee:toString()
    end
end

return InfoBoxSystem
