local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local events = require "core.events.events"
local StateSystem = class("StateSystem", System)
StateSystem:include(Serializable)

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
