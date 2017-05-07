local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local HirePurchaseEvent = class("HirePurchaseEvent")
HirePurchaseEvent:include(Serializable)

function HirePurchaseEvent:initialize(args)
    args = args or {}
    assert(args.unitName)
    self.unitName = args.unitName
end

return HirePurchaseEvent
