local class = require "lib.middleclass"
local events = require "core.events.events"
local systems = require "core.systems.systems"
local Serializable = require "data.serializable"
local DeathSystem = class("DeathSystem", System)
DeathSystem:include(Serializable)

function DeathSystem:initialize()
    self.name = "DeathSystem"
end

function DeathSystem:onNotify(DeathEvent)
  local deadEntity = systems.getEntityById(DeathEvent.entityId)
  
  --one in 3 chance of dropping gold
  events.fireEvent(events.SpawnEvent{
      name="Gold", 
      amount=100, 
      stock=false, 
      x=deadEntity.Physics.x, 
      y=deadEntity.Physics.y
    })

  
  events.fireEvent(events.LogEvent{text=deadEntity.name .. " dies."})
  systems.removeEntity(deadEntity)
  
end

return DeathSystem
