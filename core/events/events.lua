local serpent = require "serpent"
local lovetoys = require "lib.lovetoys.lovetoys"
local systems = require "core.systems.systems"
local events = {}

events.KeyPressEvent = require "core.events.KeyPressEvent"
events.LogEvent = require "core.events.LogEvent"
events.MoveEvent = require "core.events.MoveEvent"
events.TurnEvent = require "core.events.TurnEvent"
events.SaveEvent = require "core.events.SaveEvent"
events.LoadEvent = require "core.events.LoadEvent"
events.LevelEvent = require "core.events.LevelEvent"
events.ReplayEvent = require "core.events.ReplayEvent"
events.ToggleRecordingEvent = require "core.events.ToggleRecordingEvent"
events.FocusEvent = require "core.events.FocusEvent"
events.StateEvent = require "core.events.StateEvent"
events.ReservesEnterEvent = require "core.events.ReservesEnterEvent"
events.ReservesExitEvent = require "core.events.ReservesExitEvent"

function events.init()

    events.eventManager = lovetoys.EventManager()
    events.eventManager:addListener("KeyPressEvent", systems.commandKeyPressSystem, systems.commandKeyPressSystem.onNotify)
    events.eventManager:addListener("MoveEvent", systems.moveSystem, systems.moveSystem.onNotify)
    events.eventManager:addListener("MoveEvent", systems.replaySystem, systems.replaySystem.pushEvent)
    events.eventManager:addListener("LogEvent", systems.logSystem, systems.logSystem.onNotify)
    events.eventManager:addListener("TurnEvent", systems.turnSystem, systems.turnSystem.onNotify)
    events.eventManager:addListener("SaveEvent", systems.saveSystem, systems.saveSystem.onSaveNotify)
    events.eventManager:addListener("LoadEvent", systems.saveSystem, systems.saveSystem.onLoadNotify)
    events.eventManager:addListener("LevelEvent", systems.levelSystem, systems.levelSystem.onNotify)
    events.eventManager:addListener("ReplayEvent", systems.replaySystem, systems.replaySystem.popEvent)
    events.eventManager:addListener("ToggleRecording", systems.replaySystem, systems.replaySystem.toggleRecording)
    events.eventManager:addListener("FocusEvent", systems.targetSystem, systems.targetSystem.onFocusNotify)
    events.eventManager:addListener("StateEvent", systems.stateSystem, systems.stateSystem.onNotify)
    events.eventManager:addListener("ReservesEnterEvent", systems.reservesSystem, systems.reservesSystem.onEnterNotify)
    events.eventManager:addListener("ReservesExitEvent", systems.reservesSystem, systems.reservesSystem.onExitNotify)

    if not game.options.headless then
        --promptSystem
        events.eventManager:addListener("LogEvent", systems.promptSystem, systems.promptSystem.flushPrompt)

        --infoBoxSystem
        events.eventManager:addListener("FocusEvent", systems.infoBoxSystem, systems.infoBoxSystem.onFocusNotify)
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
