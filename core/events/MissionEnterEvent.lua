local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local MissionEnterEvent = class("MissionEnterEvent")
MissionEnterEvent:include(Serializable)

function MissionEnterEvent:initialize(args)
    args = args or {}
    self.entityId = args.entityId
end

return MissionEnterEvent
