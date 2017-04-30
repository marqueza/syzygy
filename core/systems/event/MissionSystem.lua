local class = require "lib.middleclass"
local components = require "core.components.components"
local Serializable = require "data.serializable"
local events = require "core.events.events"
local MissionSystem = class("MissionSystem", System)
MissionSystem:include(Serializable)

function MissionSystem:initialize()
    self.name = "MissionSystem"
end

function MissionSystem:onEnterNotify(MissionEnterEvent)
    local e = systems.getEntityById(MissionEnterEvent.entityId)
    if e:has("Sprite") then
        e.Sprite.isVisible = false
    end
    if e:has("Physics") then
        e:remove("Physics")
    end
    e:add(components.Mission({turnsRemaining=3}))
end

function MissionSystem:onTurnNotify(TurnEvent)
    local missionEntities = systems.getEntitiesWithComponent("Mission")
    for k, e in pairs(missionEntities) do
        print(e.Mission.turnsRemaining)
        e.Mission.turnsRemaining = e.Mission.turnsRemaining-1
        if e.Mission.turnsRemaining < 1 then
            events.fireEvent(events.MissionExitEvent{entityId=e.id})
        end
    end
end

function MissionSystem:onExitNotify(MissionExitEvent)
    local e = systems.getEntityById(MissionExitEvent.entityId)
    if e:has("Sprite") then
        e.Sprite.isVisible = true
    end
    e:remove("Mission")
end

return MissionSystem
