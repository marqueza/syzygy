local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local TurnEvent = class("TurnEvent")
TurnEvent:include(Serializable)

function TurnEvent:initialize(args)
    args = args or {}
end

return TurnEvent
