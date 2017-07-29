local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local InventoryEnterEvent = class("InventoryEnterEvent")
InventoryEnterEvent:include(Serializable)

function InventoryEnterEvent:initialize(args)
    args = args or {}
    self.itemId = args.itemId
    self.holderId = args.holderId
end

return InventoryEnterEvent
