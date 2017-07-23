local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local AttackEvent = class("AttackEvent")
AttackEvent:include(Serializable)

function AttackEvent:initialize(args)
    assert(args)
    args = args
    self.attackerId = args.attackerId
    self.defenderId = args.defenderId
end

return AttackEvent
