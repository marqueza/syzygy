local MessageSystem = class("MessageSystem", System)
function MessageSystem:initialize()
    self.logFile = love.filesystem.newFile("log.txt")
    self.logFile:open("a")
end
function MessageSystem:fireEvent(messageEvent)
    engine.ui.messageBox.textarea:addText( engine.turn .. messageEvent.text .. "\n")
    self.logFile:write(engine.turn .. messageEvent.text)
    return
end
return MessageSystem