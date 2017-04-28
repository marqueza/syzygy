local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local ReservesEvent = class("ReservesEvent")
ReservesEvent:include(Serializable)

function ReservesEvent:initialize(args)
    args = args or {}
    self.entityId = args.entityId
end

return ReservesEvent
