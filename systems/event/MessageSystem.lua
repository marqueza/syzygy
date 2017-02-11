local MessageSystem = class("MessageSystem", System)

function MessageSystem:fireEvent(messageEvent)
    table.insert(engine.messageLog, engine.turn .. messageEvent.text)
    return
end

return MessageSystem