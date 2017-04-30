local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local MissionExitEvent = class("MissionExitEvent")
MissionExitEvent:include(Serializable)

function MissionExitEvent:initialize(args)
    args = args or {}
    self.entityId = args.entityId
end

return MissionExitEvent
