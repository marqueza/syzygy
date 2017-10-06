local lovetoys = "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local events = require "core.events.events"
local HarvestSystem = class("HarvestSystem", System)

--This class determines what occurs when a resource is harvested
function HarvestSystem:initialize()
    self.name = "HarvestSystem"
end
function HarvestSystem:onNotify(harvestEvent)
    --harvest event holds the id of what is going to be harvested
    local resourceEntity = systems.getEntityById(harvestEvent.entityId)
    assert(resourceEntity)
    assert(resourceEntity.Harvest)
    events.fireEvent(events.SpawnEvent{
        name=resourceEntity.Harvest.loot, 
        x=resourceEntity.Physics.x,
        y=resourceEntity.Physics.y, 
        plane=resourceEntity.Physics.plane})
    systems.removeEntity(resourceEntity)
    
end
return HarvestSystem
