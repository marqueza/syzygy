local class = require "lib.middleclass"
local TurnEvent = class("TurnEvent")

function TurnEvent:initialize()
    self.name = "TurnEvent"
end

return TurnEvent
