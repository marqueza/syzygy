local serpent = require "serpent"
local lovetoys = require "lib.lovetoys.lovetoys"
local systems = require "core.systems.systems"
local events = {}

events.CommandKeyEvent = require "core.events.CommandKeyEvent"
events.MessageEvent = require "core.events.MessageEvent"
events.MoveEvent = require "core.events.MoveEvent"
events.TurnEvent = require "core.events.TurnEvent"

function events.init()

    events.eventManager = lovetoys.EventManager()

    events.eventManager:addListener("CommandKeyEvent", systems.commandKeySystem, systems.commandKeySystem.fireEvent)
    events.eventManager:addListener("MoveEvent", systems.moveSystem, systems.moveSystem.fireEvent)
    events.eventManager:addListener("MessageEvent", systems.messageSystem, systems.messageSystem.fireEvent)
    events.eventManager:addListener("TurnEvent", systems.turnSystem, systems.turnSystem.fireEvent)

    if not game.options.headless then
        events.eventManager:addListener("TurnEvent", systems.promptSystem, systems.promptSystem.flushPrompt)
    end
end

function events.fireEvent(event)
    if game.options.debug then
        if event.reflect then
            events.eventManager:fireEvent(events.MessageEvent("[DEBUG] Firing " ..  serpent.line(event:reflect(), {comment=false})))
        end
    end
    events.eventManager:fireEvent(event)
end
return events
