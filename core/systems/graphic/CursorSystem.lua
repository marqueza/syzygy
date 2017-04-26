local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local CursorSystem = class("CursorSystem", lovetoys.System)

function CursorSystem:initialize()
    lovetoys.System.initialize(self)
    self.image = love.graphics.newImage('res/img/sprites/cursor.png')
    self.gridSize = 64
end

function CursorSystem:draw()

    local focus = systems.targetSystem.focus
    if focus then
        love.graphics.setColor(255, 255, 255, 200)
        love.graphics.draw(
            self.image,
            focus.Physics.x*self.gridSize-self.gridSize-4,
            focus.Physics.y*self.gridSize-self.gridSize-4)
        love.graphics.setColor(255, 255, 255, 255)
    end
end

function CursorSystem:requires()
    return {}
end

return CursorSystem
