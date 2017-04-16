local lovetoys = "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local LogSystem = class("LogSystem", System)

function LogSystem:initialize()
    self.name = "LogSystem"
    self.messagelog = {}
    self.eventLog = {}
end
function LogSystem:onNotify(logEvent)
    if logEvent.type == "message" then
        table.insert(self.messageLog, 1, logEvent.text)
    end
    if logEvent.type == "event" then
        table.insert(self.eventLog, 1, logEvent.text)
    end
end
return LogSystem
