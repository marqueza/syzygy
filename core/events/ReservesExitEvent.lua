local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local ReservesExitEvent = class("ReservesExitEvent")
ReservesExitEvent:include(Serializable)

function ReservesExitEvent:initialize(args)
    args = args or {}
    self.entityId = args.entityId
end

return ReservesExitEvent
