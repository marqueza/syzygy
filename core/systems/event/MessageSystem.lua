local MessageSystem = class("MessageSystem", System)
function MessageSystem:initialize()
    self.logFile = love.filesystem.newFile("log.txt")
    self.logFile:open("a")
end
function MessageSystem:fireEvent(messageEvent)
    local formattedMessage = "[" .. engine.turn  .. "] " .. messageEvent.text .. "\n"
    formattedMessage = string.upper(formattedMessage)
    formattedMessage = string.gsub(formattedMessage, '{', '[')
    formattedMessage = string.gsub(formattedMessage, '}', ']')
    formattedMessage = string.gsub(formattedMessage, '\"', ' ')
    self.logFile:write(formattedMessage)
    table.insert(engine.log, 1, formattedMessage)
    PromptSystem:flushPrompt()
    return
end
return MessageSystem
