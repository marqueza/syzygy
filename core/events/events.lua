--a static class
local events = {}

--required for events
function events.load()
    eventManager = EventManager()
    --instances of event systems
    local moveSystem = MoveSystem()
    local commandKeySystem = CommandKeySystem()
    local messageSystem = MessageSystem()

    --register listeners
    eventManager:addListener("CommandKeyEvent", commandKeySystem, commandKeySystem.fireEvent)
    eventManager:addListener("MoveEvent", moveSystem, moveSystem.fireEvent)
    eventManager:addListener("MessageEvent", messageSystem, messageSystem.fireEvent)
end
function events.fireEvent(event)
    if config.debug then
        eventManager:fireEvent(MessageEvent("[DEBUG] Firing " ..  serpent.line(event:reflect(), {comment=false})))
    end
    eventManager:fireEvent(event)
end

return events
