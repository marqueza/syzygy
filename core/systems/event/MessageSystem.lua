local lovetoys = "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local MessageSystem = class("MessageSystem", System)

function MessageSystem:initialize()
    self.name = "Message System"
    self.log = {}
    self.eventLog = {}
end
function MessageSystem:onNotify(messageEvent)
    if messageEvent.type == "visual" then
        table.insert(self.log, 1, messageEvent.text)
    end
    if messageEvent.type == "event" then
        table.insert(self.eventLog, 1, messageEvent.text)
    end
end
return MessageSystem
