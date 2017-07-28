local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local StatusBoxSystem = class("StatusBoxSystem", lovetoys.System)

function StatusBoxSystem:initialize()
    lovetoys.System.initialize(self)
    self.pixelX = 500
    self.pixelY = 0
    self.text = nil
    self.examinee = nil
end
function StatusBoxSystem:draw()
    love.graphics.print(game.fps, self.pixelX, self.pixelY)
    love.graphics.print("Level: "..systems.levelSystem.currentLevelName.."-"..
        systems.levelSystem.currentLevelDepth, self.pixelX, self.pixelY+12)
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
