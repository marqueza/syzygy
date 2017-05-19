local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local CursorSystem = class("CursorSystem", lovetoys.System)

function CursorSystem:initialize()
    lovetoys.System.initialize(self)
    self.image = love.graphics.newImage('res/img/sprites/cursor.png')
    self.gridSize = game.options.spriteSize
end

function CursorSystem:draw()

    local focus = systems.targetSystem.focus
    if focus then
        love.graphics.setColor(255, 255, 255, 50)
        love.graphics.rectangle(
            "fill",
            (focus.Physics.x-1)*game.options.spriteSize,
            (focus.Physics.y-1)*game.options.spriteSize,
            game.options.spriteSize,
            game.options.spriteSize)
        love.graphics.setColor(255, 255, 255, 255)
    end
end

function CursorSystem:requires()
    return {}
end

return CursorSystem
