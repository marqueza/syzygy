local lovetoys = "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local MessageSystem = class("MessageSystem", System)

function MessageSystem:initialize()
    self.name = "Message System"
    self.log = {}
end
function MessageSystem:fireEvent(messageEvent)
    local formattedMessage = "[" .. systems.turnSystem.turn .. "] " .. messageEvent.text .. "\n"
    formattedMessage = string.upper(formattedMessage)
    formattedMessage = string.gsub(formattedMessage, '{', '[')
    formattedMessage = string.gsub(formattedMessage, '}', ']')
    formattedMessage = string.gsub(formattedMessage, '\"', ' ')
    --self.logFile:write(formattedMessage)
    table.insert(self.log, 1, formattedMessage)
    return
end
return MessageSystem
