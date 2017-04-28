local class = require "lib.middleclass"
local components = require "core.components.components"
local Serializable = require "data.serializable"
local ReservesSystem = class("ReservesSystem", System)
ReservesSystem:include(Serializable)

function ReservesSystem:initialize()
    self.name = "ReservesSystem"
end

function ReservesSystem:onEnterNotify(EnterReservesEvent)
    local e = systems.getEntityById(EnterReservesEvent.entityId)
    if e:has("Sprite") then
        e.Sprite.isVisible = false
    end
    if e:has("Physics") then
        e:remove("Physics")
    end
    e:add(Reserve())
end

function ReservesSystem:onExitNotify(ExitReservesEvent)
    local e = systems.getEntityById(ExitReservesEvent.entityId)
    if e:has("Sprite") then
        e.Sprite.isVisible = true
    end
    e:remove("Reserves")
end

return ReservesSystem
