require "core.events.TurnEvent"
local class = require "lib.middleclass"
local events = require "core.events.events"

local TurnSystem = class("TurnSystem", System)

function TurnSystem:initialize()
    self.name = "TurnSystem"
    self.turn = 1
end

function TurnSystem:fireEvent(TurnEvent)
    self.turn = self.turn+1
end

return TurnSystem
