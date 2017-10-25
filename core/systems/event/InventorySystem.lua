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
local _stackInsert
local _displayAll
local _displayUse

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
    if itemEntity.Stack then
        local success = _stackInsert(itemEntity, holderEntity)
        if success then return end
    end
    table.insert(holderEntity.Inventory.itemIds, itemEntity.id)
end

--returns true on success, false on fail
_stackInsert = function(itemEntity, holderEntity)
    for index, id in ipairs(holderEntity.Inventory.itemIds) do
        local storedEntity = systems.getEntityById(id)
        if itemEntity.name == storedEntity.name then
            if storedEntity.Stack then
                storedEntity.Stack.amount = storedEntity.Stack.amount + itemEntity.Stack.amount
                return true
            end
        end
    end
    return false
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

function InventorySystem:onDisplayNotify(inventoryDisplayEvent)
    if inventoryDisplayEvent.mode == "use" then
        _displayUse(self, inventoryDisplayEvent)
    else
        _displayAll(self, inventoryDisplayEvent)
    end
end

_displayAll = function(self, inventoryDisplayEvent)
    local holderEntity = systems.getEntityById(inventoryDisplayEvent.holderId)
    if holderEntity.Inventory == nil then
        holderEntity:add(components.Inventory({}))
    end
    events.fireEvent(events.MenuDisplayEvent{
        type="list",
        prettyChoices=self:getInventoryNames(holderEntity),
        choices=holderEntity.Inventory.itemIds,
        title="Inventory",
        resultKey="itemId",
        resultEvent=events.InventoryExitEvent,
        resultEventArgs={holderId=holderEntity.id},
    })
end

_displayUse = function(self, inventoryDisplayEvent)
    local holderEntity = systems.getEntityById(inventoryDisplayEvent.holderId)
    if holderEntity.Inventory == nil then
        holderEntity:add(components.Inventory({}))
    end
    events.fireEvent(events.MenuDisplayEvent{
        type="list",
        prettyChoices=self:getUseNames(holderEntity),
        choices=self:getUseIds(holderEntity),
        title="Use Item",
        resultKey="subjectId",
        resultEvent=events.UseEvent,
        resultEventArgs={userId=holderEntity.id},
    })
end

function InventorySystem:getUseIds(holder)
    local idList = {}
    for index, id in ipairs(holder.Inventory.itemIds) do
        local itemEntity = systems.getEntityById(id)
        if itemEntity.Use then
            table.insert(idList, itemEntity.id)
        end
    end
    return idList
end

function InventorySystem:getUseNames(holderEntity)
    local nameList = {}
    for index, id in ipairs(holderEntity.Inventory.itemIds) do
        local itemEntity = systems.getEntityById(id)
        if itemEntity.Use then
          if itemEntity.Stack then
              table.insert(nameList, itemEntity.name .. " (" .. itemEntity.Stack.amount .. ")")
          else
              table.insert(nameList, itemEntity.name)
          end
        end
    end
    return nameList
end

function InventorySystem:getInventoryNames(holderEntity)
    local nameList = {}
    for index, id in ipairs(holderEntity.Inventory.itemIds) do
        local itemEntity = systems.getEntityById(id)
        if itemEntity.Stack then
            table.insert(nameList, itemEntity.name .. " (" .. itemEntity.Stack.amount .. ")")
        else
            table.insert(nameList, itemEntity.name)
        end
    end
    return nameList
end

function InventorySystem:getItem(holderEntity, itemName)
    if holderEntity.Inventory == nil then
        holderEntity:add(components.Inventory({}))
    end

    for index, id in ipairs(holderEntity.Inventory.itemIds) do
        local itemEntity = systems.getEntityById(id)
        if itemEntity.name == itemName then
            return itemEntity
        end
    end
    return nil
end

function InventorySystem:getItemAmount(holderEntity, itemName)
    if holderEntity.Inventory == nil then
        holderEntity:add(components.Inventory({}))
    end

    for index, id in ipairs(holderEntity.Inventory.itemIds) do
        local itemEntity = systems.getEntityById(id)
        if itemEntity.name == itemName then
            if itemEntity.Stack then
                return itemEntity.Stack.amount
            else
                return 1
            end
        end
    end
    return 0
end

return InventorySystem
