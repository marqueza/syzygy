local class = require "lib.middleclass"
local components = require "core.components.components"
local Serializable = require "data.serializable"
local events = require "core.events.events"
local MissionSystem = class("MissionSystem", System)
MissionSystem:include(Serializable)

function MissionSystem:initialize()
    self.name = "MissionSystem"
end

function MissionSystem:onEmbarkNotify(MissionEmbarkEvent)
  assert(type(MissionEmbarkEvent.unitId)=="number", "Expected a number, got: "..type(MissionEmbarkEvent.unitId))
    local e = systems.getEntityById(MissionEmbarkEvent.unitId)
    events.fireEvent(events.ReservesExitEvent{entityId=e.id})

    if e:has("Sprite") then
        e.Sprite.isVisible = false
    end
    if e:has("Physics") then
        e:remove("Physics")
    end

    e:add(components.Mission({turnsRemaining=20}))
    events.fireEvent(events.LogEvent{text="["..e.id.."] " .. e.name.." embarked on a journey..."})
end

function MissionSystem:onTurnNotify(TurnEvent)
    local missionEntities = systems.getEntitiesWithComponent("Mission")
    for k, e in pairs(missionEntities) do
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
    events.fireEvent(events.ReservesEnterEvent{entityId=e.id})
    events.fireEvent(events.LogEvent{text="["..e.id.."] " .. e.name.." returned."})
end
function MissionSystem:onUnitNotify(MissionUnitEvent)
    print("onUnitNotify: ")
    events.fireEvent(events.MenuDisplayEvent{
        type="component",
        choices={"Reserve"},
        title="Select a unit in reserves:",
        resultKey="unitId",
        resultEvent=events.MissionEmbarkEvent,
        resultEventArgs={},
    })
end

function MissionSystem:onLocationNotify(MissionLocationEvent)
  assert(MissionTaskEvent, "Expected a number, got: "..MissionLocationEvent.entityId)
    events.fireEvent(events.MenuDisplayEvent{
        type="component",
        choices={"Location"},
        title="Select a location:",
        resultKey="locationId",
        resultEvent=events.MissionTaskEvent,
        resultEventArgs=MissionLocationEvent:toTable(),
    })
end
function MissionSystem:onTaskNotify(MissionTaskEvent)
  assert(MissionTaskEvent, "Expected a number, got: "..MissionTaskEvent.entityId)
    events.fireEvent(events.MenuDisplayEvent{
        type="strings",
        choices={"Journey", "Training"},
        title="Select a task:",
        resultKey="locationId",
        resultEvent=events.MissionEmbarkEvent,
        resultEventArgs=MissionTaskEvent:toTable(),
    })
end

return MissionSystem
