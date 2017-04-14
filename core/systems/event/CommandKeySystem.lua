require "core.events.MoveEvent"
local class = require "lib.middleclass"
local events = require "core.events.events"
local systems = require "core.systems.systems"

local CommandKeySystem = class("CommandKeySystem", System)

function CommandKeySystem:initialize()
    self.name = "CommandKeySystem"
end

function CommandKeySystem:onNotify(CommandKeyEvent)
    if CommandKeyEvent.key == "up" then
        for index, entity in pairs(systems.getEntitiesWithComponent("Control")) do
            local Physics = entity:get("Physics")
            events.fireEvent(events.MoveEvent(entity, Physics.x, Physics.y-1))
        end
    elseif CommandKeyEvent.key == "down" then
        for index, entity in pairs(systems.getEntitiesWithComponent("Control")) do
            local Physics = entity:get("Physics")
            events.fireEvent(events.MoveEvent(entity, Physics.x, Physics.y+1))
        end
    elseif CommandKeyEvent.key == "right" then
        for index, entity in pairs(systems.getEntitiesWithComponent("Control")) do
            local Physics = entity:get("Physics")
            events.fireEvent(events.MoveEvent(entity, Physics.x+1, Physics.y))
        end
    elseif CommandKeyEvent.key == "left" then
        for index, entity in pairs(systems.getEntitiesWithComponent("Control")) do
            local Physics = entity:get("Physics")
            events.fireEvent(events.MoveEvent(entity, Physics.x-1, Physics.y))
        end
    elseif CommandKeyEvent.key == "s" then
        events.fireEvent(events.SaveEvent())
    elseif CommandKeyEvent.key == "l" then
        events.fireEvent(events.LoadEvent())
    end
end

return CommandKeySystem
