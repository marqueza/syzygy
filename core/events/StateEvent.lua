local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local StateEvent = class("StateEvent")
StateEvent:include(Serializable)

function StateEvent:initialize(args)
    args = args or {}
    self.state = args.state
end

function StateEvent:getState()
    return self.state
end
return StateEvent
