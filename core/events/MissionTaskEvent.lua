local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local MissionTaskEvent = class("MissionTaskEvent")
MissionTaskEvent:include(Serializable)

function MissionTaskEvent:initialize(args)
    args = args or {}
    self.task = args.task
end

return MissionTaskEvent
