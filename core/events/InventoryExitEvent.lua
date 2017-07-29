local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local InventoryExitEvent = class("InventoryExitEvent")
InventoryExitEvent:include(Serializable)

function InventoryExitEvent:initialize(args)
    args = args or {}
     self.itemId = args.itemId
    self.holderId = args.holderId
end

return InventoryExitEvent