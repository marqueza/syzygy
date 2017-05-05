local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local MissionEmbarkEvent = class("MissionEmbarkEvent")
MissionEmbarkEvent:include(Serializable)

function MissionEmbarkEvent:initialize(args)
    args = args or {}
    self.unitId = args.unitId
end

return MissionEmbarkEvent
