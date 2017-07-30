local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local DeathEvent = class("DeathEvent")
DeathEvent:include(Serializable)

function DeathEvent:initialize(args)
    assert(args)
    args = args
    self.entityId = args.entityId
end

return DeathEvent
