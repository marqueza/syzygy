local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local MissionEmbarkEvent = class("MissionEmbarkEvent")
MissionEmbarkEvent:include(Serializable)

function MissionEmbarkEvent:initialize(args)
    assert(type(args.unitId)=="number", "Expected a number, got: "..type(args.unitId))
    assert(type(args.turnsRemaining)=="number", "Expected a number, got: "..type(args.turnsRemaining))
    self.unitId = args.unitId
    self.turnsRemaining = args.turnsRemaining
end

return MissionEmbarkEvent
