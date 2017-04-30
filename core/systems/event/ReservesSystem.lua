local class = require "lib.middleclass"
local components = require "core.components.components"
local Serializable = require "data.serializable"
local ReservesSystem = class("ReservesSystem", System)
ReservesSystem:include(Serializable)

function ReservesSystem:initialize()
    self.name = "ReservesSystem"
end

function ReservesSystem:onEnterNotify(ReservesEnterEvent)
    assert(ReservesEnterEvent.entityId)
    local e = systems.getEntityById(ReservesEnterEvent.entityId)
    if e:has("Sprite") then
        e.Sprite.isVisible = false
    end
    if e:has("Physics") then
        e:remove("Physics")
    end
    e:add(components.Reserve())
    assert(e:has("Reserve"))
end

function ReservesSystem:onExitNotify(ExitReservesEvent)
    local e = systems.getEntityById(ExitReservesEvent.entityId)
    if e:has("Sprite") then
        e.Sprite.isVisible = true
    end
    e:remove("Reserve")
end

return ReservesSystem
