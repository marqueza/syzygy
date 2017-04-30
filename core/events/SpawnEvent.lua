local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local SpawnEvent = class("SpawnEvent")
SpawnEvent:include(Serializable)

function SpawnEvent:initialize(args)
    args = args or {}
end

return SpawnEvent
