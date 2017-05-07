local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local SpawnEvent = class("SpawnEvent")
SpawnEvent:include(Serializable)

function SpawnEvent:initialize(args)
    assert(args)
    self.args = args or {}
    self.name = args.name
    self.reserve = args.reserve
    self.stock = args.stock
end

return SpawnEvent
