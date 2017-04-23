require "core.events.MoveEvent"
local class = require "lib.middleclass"
local events = require "core.events.events"
local systems = require "core.systems.systems"

local KeyPressSystem = class("KeyPressSystem", System)

function KeyPressSystem:initialize()
    self.name = "KeyPressSystem"
end

function KeyPressSystem:onNotify(KeyPressEvent)
    local state = systems.stateSystem:getState()
    if state == "command" then
        self:doCommandKey(KeyPressEvent)
    elseif state == "focus" then
        self:doFocusKey(KeyPressEvent)
    end
end

function KeyPressSystem:doFocusKey(KeyPressEvent)
    if KeyPressEvent.key == "up" then
        events.fireEvent(events.FocusEvent{dx=0, dy=-1})
    elseif KeyPressEvent.key == "down" then
        events.fireEvent(events.FocusEvent{dx=0, dy=1})
    elseif KeyPressEvent.key == "left" then
        events.fireEvent(events.FocusEvent{dx=-1, dy=0})
    elseif KeyPressEvent.key == "right" then
        events.fireEvent(events.FocusEvent{dx=1, dy=0})
    elseif KeyPressEvent.key == '.' or
            KeyPressEvent.key == "return" or
            KeyPressEvent.key == "l" then
        events.fireEvent(events.StateEvent{state="command"})
    end
end
function KeyPressSystem:doCommandKey(KeyPressEvent)
    if KeyPressEvent.key == "up" then
        for index, entity in pairs(systems.getEntitiesWithComponent("Control")) do
            local Physics = entity:get("Physics")
            events.fireEvent(events.MoveEvent( {
                moverId=entity.id,
                x=Physics.x,
                y=Physics.y-1
            }))
        end
    elseif KeyPressEvent.key == "down" then
        for index, entity in pairs(systems.getEntitiesWithComponent("Control")) do
            local Physics = entity:get("Physics")
            events.fireEvent(events.MoveEvent( {
                moverId=entity.id,
                x=Physics.x,
                y=Physics.y+1
            }))
        end
    elseif KeyPressEvent.key == "right" then
        for index, entity in pairs(systems.getEntitiesWithComponent("Control")) do
            local Physics = entity:get("Physics")
            events.fireEvent(events.MoveEvent( {
                moverId=entity.id,
                x=Physics.x+1,
                y=Physics.y
            }))
        end
    elseif KeyPressEvent.key == "left" then
        for index, entity in pairs(systems.getEntitiesWithComponent("Control")) do
            local Physics = entity:get("Physics")
            events.fireEvent(events.MoveEvent( {
                moverId=entity.id,
                x=Physics.x-1,
                y=Physics.y
            }))
        end
    elseif KeyPressEvent.key == "s" then
        events.fireEvent(events.SaveEvent())
    elseif KeyPressEvent.key == "l" and (
            love.keyboard.isDown("lshift") or
            love.keyboard.isDown("rshift")) then
        events.fireEvent(events.LoadEvent())
    elseif KeyPressEvent.key == "r" then
        events.fireEvent(events.ReplayEvent())
    elseif KeyPressEvent.key == "q" then
        events.fireEvent(events.ToggleRecordingEvent())
    elseif KeyPressEvent.key == "." or KeyPressEvent.key == "l" then
        events.fireEvent(events.StateEvent{state="focus"})
    end
end

return KeyPressSystem
