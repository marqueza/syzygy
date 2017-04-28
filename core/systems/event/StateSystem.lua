local class = require "lib.middleclass"
local StateSystem = class("StateSystem", System)

function StateSystem:initialize()
    self.name = "StateSytem"
    self.state = "command"
end

function StateSystem:onNotify(stateEvent)
    self.state = stateEvent.state
end

function StateSystem:getState()
    return self.state
end

return StateSystem
