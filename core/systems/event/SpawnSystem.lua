local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local Factory = require "core.factories.entity.Factory"
local systems = require "core.systems.systems"
local events = require "core.events.events"
local SpawnSystem = class("SpawnSystem", System)
SpawnSystem:include(Serializable)

function SpawnSystem:initialize()
    self.name = "SpawnSystem"
end

function SpawnSystem:onNotify(SpawnEvent)
    assert(SpawnEvent.args)
    assert(SpawnEvent.args.name)
    assert(type(Factory[SpawnEvent.args.name])=="function", SpawnEvent.args.name .. " does not exit as a function in Factory directory")
    local e = Factory[SpawnEvent.args.name](SpawnEvent.args)
    systems.addEntity(e)
    if SpawnEvent.args.stock then
        events.fireEvent(events.StockEnterEvent{entityId=e.id})
    end
    if SpawnEvent.args.reserve then
        events.fireEvent(events.ReservesEnterEvent{entityId=e.id})
    end
end

return SpawnSystem
