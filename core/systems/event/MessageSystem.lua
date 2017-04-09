local MessageSystem = class("MessageSystem", System)
local engine = require "core.engine"
function MessageSystem:initialize()
    --[[
    self.logFile = love.filesystem.newFile("log.txt")
    self.logFile:open("a")
    --]]
end
function MessageSystem:fireEvent(messageEvent)
    local formattedMessage = "[" .. game.turn  .. "] " .. messageEvent.text .. "\n"
    formattedMessage = string.upper(formattedMessage)
    formattedMessage = string.gsub(formattedMessage, '{', '[')
    formattedMessage = string.gsub(formattedMessage, '}', ']')
    formattedMessage = string.gsub(formattedMessage, '\"', ' ')
    --self.logFile:write(formattedMessage)
    table.insert(game.log, 1, formattedMessage)
    PromptSystem:flushPrompt()
    return
end
return MessageSystem
