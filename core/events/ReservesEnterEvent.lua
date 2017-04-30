local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local ReservesEnterEvent = class("ReservesEnterEvent")
ReservesEnterEvent:include(Serializable)

function ReservesEnterEvent:initialize(args)
    args = args or {}
    self.entityId = args.entityId
end

return ReservesEnterEvent
