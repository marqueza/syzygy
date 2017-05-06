local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local StockDisplayEvent = class("StockDisplayEvent")
StockDisplayEvent:include(Serializable)

function StockDisplayEvent:initialize(args)
    args = args or {}
    self.entityId = args.entityId
end

return StockDisplayEvent
