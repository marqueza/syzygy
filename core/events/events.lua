local events = {}

function events.init()
    require "core.systems.event.MessageSystem"
    require "core.systems.event.CommandKeySystem"
    require "core.systems.event.MoveSystem"


    events.eventManager = EventManager()

    local moveSystem = MoveSystem()
    local commandKeySystem = CommandKeySystem()
    local messageSystem = MessageSystem()

    events.eventManager:addListener("CommandKeyEvent", commandKeySystem, commandKeySystem.fireEvent)
    events.eventManager:addListener("MoveEvent", moveSystem, moveSystem.fireEvent)
    events.eventManager:addListener("MessageEvent", messageSystem, messageSystem.fireEvent)
end

function events.fireEvent(event)
    if game.options.debug then
        events.eventManager:fireEvent(MessageEvent("[DEBUG] Firing " ..  serpent.line(event:reflect(), {comment=false})))
    end
    events.eventManager:fireEvent(event)
end
return events
