local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local StockExitEvent = class("StockExitEvent")
StockExitEvent:include(Serializable)

function StockExitEvent:initialize(args)
    args = args or {}
    self.entityId = args.entityId
end

return StockExitEvent
