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
  
  if deadEntity.Recruit and deadEntity.Recruit.leaderId then
    local leader = systems.getEntityById(deadEntity.Recruit.leaderId)
    for i, id in ipairs(leader.Party.memberIds) do
      if deadEntity.id == id then
        table.remove(leader.Party.memberIds, i)
      end
    end
  end
  --one in 3 chance of dropping gold
  events.fireEvent(events.SpawnEvent{
      name="Gold", 
      amount=3, 
      stock=false, 
      x=deadEntity.Physics.x, 
      y=deadEntity.Physics.y,
      plane=deadEntity.Physics.plane
    })

  
  events.fireEvent(events.LogEvent{text=deadEntity.name .. " dies."})
  systems.removeEntity(deadEntity)
  
end

return DeathSystem
