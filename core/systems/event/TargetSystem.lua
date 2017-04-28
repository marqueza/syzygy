local class = require "lib.middleclass"
--local Serializable = require "data.serializable"
local events = require "core.events.events"
local TargetSystem = class("TargetSystem", System)

function TargetSystem:initialize()
    self.name = "TargetSystem"
    self.target = nil
    self.focus = nil
end

function TargetSystem:onFocusNotify(focusEvent)
    if focusEvent.unfocus then
        self.focus = nil
        return
    end

    if self.focus then
        if focusEvent.dx and focusEvent.dy then
            focusEvent.x = self.focus.Physics.x + focusEvent.dx
            focusEvent.y = self.focus.Physics.y + focusEvent.dy
        end
    else
        if focusEvent.dx and focusEvent.dy then
            focusEvent.x = game.player.Physics.x + focusEvent.dx
            focusEvent.y = game.player.Physics.y + focusEvent.dy
        end
    end


    for i, e in pairs(systems.getEntitiesWithComponent("Physics")) do
        if focusEvent.x == e.Physics.x and focusEvent.y == e.Physics.y and e.Physics.blocks then
            self.focus = e
            return
        end
    end
    for i, e in pairs(systems.getEntitiesWithComponent("Physics")) do
        if focusEvent.x == e.Physics.x and focusEvent.y == e.Physics.y then
            self.focus = e
            return
        end
    end
end

return TargetSystem
