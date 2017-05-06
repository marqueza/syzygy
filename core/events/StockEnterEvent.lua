local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local StockEnterEvent = class("StockEnterEvent")
StockEnterEvent:include(Serializable)

function StockEnterEvent:initialize(args)
    args = args or {}
    self.entityId = args.entityId
end

return StockEnterEvent
