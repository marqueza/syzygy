local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local HarvestEvent = class("HarvestEvent")
HarvestEvent:include(Serializable)

function HarvestEvent:initialize(args)
    assert(args)
    args = args
    self.entityId = args.entityId
end

return HarvestEvent