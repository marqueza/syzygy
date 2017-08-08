local class = require "lib.middleclass"
local components = require "core.components.components"
local events = require "core.events.events"
local systems = require "core.systems.systems"
local Serializable = require "data.serializable"
local StockSystem = class("StockSystem", System)
StockSystem:include(Serializable)

function StockSystem:initialize()
    self.name = "StockSystem"
end

function StockSystem:onEnterNotify(StockEnterEvent)
    assert(StockEnterEvent.entityId)
    local e = systems.getEntityById(StockEnterEvent.entityId)
    if e:has("Sprite") then
        e.Sprite.isVisible = false
    end
    if e:has("Physics") then
        e:remove("Physics")
    end
    e:add(components.Stock())
    assert(e:has("Stock"))
end

function StockSystem:onExitNotify(StockExitEvent)
    local e = systems.getEntityById(StockExitEvent.entityId)
    if not e:has("Stock") then
        return
    end
    if e:has("Sprite") then
        e.Sprite.isVisible = true
    end
    e:remove("Stock")
end

function StockSystem:onDisplayNotify(StockDisplayEvent)
    events.fireEvent(events.MenuDisplayEvent{
        type="component",
        choices={"Stock"},
        title="Current supplies in stock:"
    })
end

return StockSystem
