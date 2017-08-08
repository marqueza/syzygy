local class = require "lib.middleclass"
local components = require "core.components.components"
local events = require "core.events.events"
local systems = require "core.systems.systems"
local Serializable = require "data.serializable"
local InventorySystem = class("InventorySystem", System)
InventorySystem:include(Serializable)

function InventorySystem:initialize()
    self.name = "InventorySystem"
end

function InventorySystem:onEnterNotify(InventoryEnterEvent)
    local itemEntity = systems.getEntityById(InventoryEnterEvent.itemId)
    local holderEntity = systems.getEntityById(InventoryEnterEvent.holderId)
    
    if holderEntity.Inventory == nil then
      holderEntity:add(components.Inventory({}))
    end
    
    if itemEntity.Sprite then
        itemEntity.Sprite.isVisible = false
    end
    if itemEntity.Physics then
      systems.planeSystem:reposition(itemEntity, -1, -1)
    end
    table.insert(holderEntity.Inventory.itemIds, itemEntity.id)
end

function InventorySystem:onExitNotify(InventoryExitEvent)
    local itemEntity = systems.getEntityById(InventoryExitEvent.itemId)
    local holderEntity = systems.getEntityById(InventoryExitEvent.holderId)
    if itemEntity.Sprite then
        itemEntity.Sprite.isVisible = true
    end
    if itemEntity.Physics then
      systems.planeSystem:reposition(itemEntity, holderEntity.Physics.x, holderEntity.Physics.y, holderEntity.Physics.plane)
    end
    
    --now remove the item from the holder inventory
    for i, itemId in ipairs(holderEntity.Inventory.itemIds) do
      if itemId == itemEntity.id then
        table.remove(holderEntity.Inventory.itemIds, i)
        break
      end
    end
end

function InventorySystem:onDisplayNotify(InventoryDisplayEvent)
    local holderEntity = systems.getEntityById(InventoryDisplayEvent.holderId)
    if holderEntity.Inventory == nil then
      holderEntity:add(components.Inventory({}))
    end
    events.fireEvent(events.MenuDisplayEvent{
        type="list",
        choices=holderEntity.Inventory.itemIds,
        title="Current items in inventory:",
        resultKey="itemId",
        resultEvent=events.InventoryExitEvent,
        resultEventArgs={holderId=holderEntity.id},
    })
end

return InventorySystem
