local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local events = require "core.events.events"
local TargetSystem = class("TargetSystem", System)

function TargetSystem:initialize()
    self.name = "TargetSystem"
    self.target = nil
    self.focus = nil
end

function TargetSystem:onFocusNotify(focusEvent)

    if focusEvent.dx and focusEvent.dy then
        focusEvent.x = self.focus.Physics.x + focusEvent.dx
        focusEvent.y = self.focus.Physics.y + focusEvent.dy
    end

    for i, e in pairs(systems.getEntitiesWithComponent("Physics")) do
        if focusEvent.x == e.Physics.x and focusEvent.y == e.Physics.y and e.Physics.blocks then
            self.focus = e
            events.fireEvent(events.LogEvent{
                text="[FOCUS] " .. self.focus.name,
            })
            return
        end
    end
    for i, e in pairs(systems.getEntitiesWithComponent("Physics")) do
        if focusEvent.x == e.Physics.x and focusEvent.y == e.Physics.y then
            self.focus = e
            events.fireEvent(events.LogEvent{
                text="[FOCUS] " .. self.focus.name,
            })
            return
        end
    end
end

return TargetSystem
