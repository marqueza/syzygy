local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local LevelEvent = class("LevelEvent")
LevelEvent:include(Serializable)

function LevelEvent:initialize(args)
    self.levelName = args.levelName
    self.options = args.options
end

return LevelEvent
