local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local TurnSystem = class("TurnSystem", System)
TurnSystem:include(Serializable)

function TurnSystem:initialize()
    self.name = "TurnSystem"
    self.turn = 1
end

function TurnSystem:onNotify(TurnEvent)
    self.turn = self.turn+1
end

return TurnSystem
