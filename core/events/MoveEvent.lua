local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local MoveEvent = class("MoveEvent")
MoveEvent:include(Serializable)

function MoveEvent:initialize(mover, newX, newY)
    self.mover = mover
    self.x = newX
    self.y = newY
end

return MoveEvent
