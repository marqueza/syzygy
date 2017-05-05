local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local MissionLocationEvent = class("MissionLocationEvent")
MissionLocationEvent:include(Serializable)

function MissionLocationEvent:initialize(args)
    args = args or {}
    self.locationId = args.locationId
end

return MissionLocationEvent
