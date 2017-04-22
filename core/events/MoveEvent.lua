local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local MoveEvent = class("MoveEvent")
MoveEvent:include(Serializable)

function MoveEvent:initialize(args)
    self.moverId = args.moverId
    self.x = args.x
    self.y = args.y
end

return MoveEvent
