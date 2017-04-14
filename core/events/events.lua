local serpent = require "serpent"
local lovetoys = require "lib.lovetoys.lovetoys"
local systems = require "core.systems.systems"
local events = {}

events.CommandKeyEvent = require "core.events.CommandKeyEvent"
events.MessageEvent = require "core.events.MessageEvent"
events.MoveEvent = require "core.events.MoveEvent"
events.TurnEvent = require "core.events.TurnEvent"
events.SaveEvent = require "core.events.SaveEvent"
events.LoadEvent = require "core.events.LoadEvent"

function events.init()

    events.eventManager = lovetoys.EventManager()

    events.eventManager:addListener("CommandKeyEvent", systems.commandKeySystem, systems.commandKeySystem.onNotify)
    events.eventManager:addListener("MoveEvent", systems.moveSystem, systems.moveSystem.onNotify)
    events.eventManager:addListener("MessageEvent", systems.messageSystem, systems.messageSystem.onNotify)
    events.eventManager:addListener("TurnEvent", systems.turnSystem, systems.turnSystem.onNotify)
    events.eventManager:addListener("SaveEvent", systems.saveSystem, systems.saveSystem.onSaveNotify)
    events.eventManager:addListener("LoadEvent", systems.saveSystem, systems.saveSystem.onLoadNotify)

    if not game.options.headless then
        events.eventManager:addListener("TurnEvent", systems.promptSystem, systems.promptSystem.flushPrompt)
        events.eventManager:addListener("SaveEvent", systems.promptSystem, systems.promptSystem.flushPrompt)
        events.eventManager:addListener("LoadEvent", systems.promptSystem, systems.promptSystem.flushPrompt)
    end
end

function events.fireEvent(event)
    if game.options.debug then
        if event.toString then
            events.eventManager:fireEvent(events.MessageEvent("[DEBUG] " .. event:toString()))
        end
    end
    events.eventManager:fireEvent(event)
end
return events
