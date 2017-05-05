local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local MissionUnitEvent = class("MissionUnitEvent")
MissionUnitEvent:include(Serializable)

function MissionUnitEvent:initialize(args)
    args = args or {}
    self.unitId = args.unitId
end

return MissionUnitEvent
