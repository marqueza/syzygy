local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local InventoryDisplayEvent = class("InventoryDisplayEvent")
InventoryDisplayEvent:include(Serializable)

function InventoryDisplayEvent:initialize(args)
    args = args or {}
    self.holderId = args.holderId
    self.mode = args.mode or "all"
end

return InventoryDisplayEvent
