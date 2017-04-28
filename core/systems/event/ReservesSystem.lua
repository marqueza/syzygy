local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local ReservesSystem = class("ReservesSystem", System)
ReservesSystem:include(Serializable)

function ReservesSystem:initialize()
    self.name = "ReservesSystem"
    self.reservesList = {}
end

function ReservesSystem:onNotify(ReservesEvent)
    table.insert(self.reservesList, ReservesEvent.entityId)
end

return ReservesSystem
