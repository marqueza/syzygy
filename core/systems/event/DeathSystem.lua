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
  
  if deadEntity.Follower and deadEntity.Follower.leaderId then
    local leader = systems.getEntityById(deadEntity.Follower.leaderId)
    if leader.Party.members[deadEntity.id] then
      leader.Party.members[deadEntity.id] = nil
    end
  end
  --one in 3 chance of dropping gold
  if math.random(3) == 1 then
    events.fireEvent(events.SpawnEvent{
        name="Gold", 
        amount=math.random(5), 
        stock=false, 
        x=deadEntity.Physics.x, 
        y=deadEntity.Physics.y,
        plane=deadEntity.Physics.plane
      })
  end
  --drop inventory if needed
  if deadEntity.Inventory then
    for index, itemId in ipairs(deadEntity.Inventory.itemIds) do
      events.fireEvent(events.InventoryExitEvent{holderId=deadEntity.id, itemId=itemId})
    end
  end
  
  events.fireEvent(events.LogEvent{text=deadEntity.name .. " dies."})
  systems.removeEntity(deadEntity)
  
end

return DeathSystem
