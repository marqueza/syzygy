local class = require "lib.middleclass"
local events = require "core.events.events"
local Serializable = require "data.serializable"
local HireSystem = class("HireSystem", System)
HireSystem:include(Serializable)

function HireSystem:initialize()
    self.name = "HireSystem"
end

function HireSystem:onBrowseNotify(HireBrowseEvent)
    events.fireEvent(events.MenuDisplayEvent{
        type="string",
        choices={"Apprentice"},
        title="Select a unit to hire:",
        resultKey="unitName",
        resultEvent=events.HirePurchaseEvent,
        resultEventArgs={turnsRemaining=10},
    })
end
function HireSystem:onPurchaseNotify(HirePurchaseEvent)
    if HirePurchaseEvent.unitName == "Apprentice" then
        --if there is 100 gold, perform a check, make the deal and subtract the gold
        --for now just generate the unit
        events.fireEvent(events.SpawnEvent{name="Apprentice", reserve=true, game.player.Physics.plane})
    end
end

return HireSystem
