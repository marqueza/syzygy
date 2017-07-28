local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local LevelEvent = class("LevelEvent")
LevelEvent:include(Serializable)

function LevelEvent:initialize(args)
    args = args or {}
    self.levelName = args.levelName
    self.levelDepth = args.levelDepth
    self.options = args.options or {}
    self.travelerIds = args.travelerIds or {}
    self.entranceId = args.entranceId
end

return LevelEvent
