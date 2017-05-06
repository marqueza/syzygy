local serpent = require "serpent"
local lovetoys = require "lib.lovetoys.lovetoys"
local systems = require "core.systems.systems"
local filer = require "data.filer"
local events = {}

filer.requireDirectoryItems(events, "events", "core/events/")

function events.init()

    events.eventManager = lovetoys.EventManager()
    events.eventManager:addListener("KeyPressEvent", systems.keyPressSystem, systems.keyPressSystem.onNotify)
    events.eventManager:addListener("MoveEvent", systems.moveSystem, systems.moveSystem.onNotify)
    events.eventManager:addListener("MoveEvent", systems.replaySystem, systems.replaySystem.pushEvent)
    events.eventManager:addListener("LogEvent", systems.logSystem, systems.logSystem.onNotify)
    events.eventManager:addListener("TurnEvent", systems.turnSystem, systems.turnSystem.onNotify)
    events.eventManager:addListener("TurnEvent", systems.missionSystem, systems.missionSystem.onTurnNotify)
    events.eventManager:addListener("SaveEvent", systems.saveSystem, systems.saveSystem.onSaveNotify)
    events.eventManager:addListener("LoadEvent", systems.saveSystem, systems.saveSystem.onLoadNotify)
    events.eventManager:addListener("LevelEvent", systems.levelSystem, systems.levelSystem.onNotify)
    events.eventManager:addListener("ReplayEvent", systems.replaySystem, systems.replaySystem.popEvent)
    events.eventManager:addListener("ToggleRecording", systems.replaySystem, systems.replaySystem.toggleRecording)
    events.eventManager:addListener("FocusEvent", systems.targetSystem, systems.targetSystem.onFocusNotify)
    events.eventManager:addListener("StateEvent", systems.stateSystem, systems.stateSystem.onNotify)
    events.eventManager:addListener("ReservesEnterEvent", systems.reservesSystem, systems.reservesSystem.onEnterNotify)
    events.eventManager:addListener("ReservesExitEvent", systems.reservesSystem, systems.reservesSystem.onExitNotify)
    events.eventManager:addListener("SpawnEvent", systems.spawnSystem, systems.spawnSystem.onNotify)
    events.eventManager:addListener("MissionEmbarkEvent", systems.missionSystem, systems.missionSystem.onEmbarkNotify)
    events.eventManager:addListener("MissionExitEvent", systems.missionSystem, systems.missionSystem.onExitNotify)
    events.eventManager:addListener("MissionUnitEvent", systems.missionSystem, systems.missionSystem.onUnitNotify)
    events.eventManager:addListener("MissionLocationEvent", systems.missionSystem, systems.missionSystem.onLocationNotify)
    events.eventManager:addListener("MissionTaskEvent", systems.missionSystem, systems.missionSystem.onTaskNotify)
    events.eventManager:addListener("StockEnterEvent", systems.stockSystem, systems.stockSystem.onEnterNotify)
    events.eventManager:addListener("StockExitEvent", systems.stockSystem, systems.stockSystem.onExitNotify)
    events.eventManager:addListener("StockDisplayEvent", systems.stockSystem, systems.stockSystem.onDisplayNotify)

    if not game.options.headless then
        events.eventManager:addListener("LogEvent", systems.promptSystem, systems.promptSystem.flushPrompt)
        events.eventManager:addListener("FocusEvent", systems.infoBoxSystem, systems.infoBoxSystem.onFocusNotify)
        events.eventManager:addListener("MenuCommandEvent", systems.menuSystem, systems.menuSystem.onCommmandNotify)
        events.eventManager:addListener("MenuDisplayEvent", systems.menuSystem, systems.menuSystem.onDisplayNotify)
    end
end

function events.fireEvent(event)
    if event.toString then
        if game.options.debug then
            events.eventManager:fireEvent(events.LogEvent{
                text="[DEBUG] " .. event:toString(),
                })
        end
        events.eventManager:fireEvent(events.LogEvent{
            text=event:toString(),
            type="event"})
    end
    events.eventManager:fireEvent(event)
end
return events
