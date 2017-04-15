local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local LevelEvent = class("LevelEvent")
LevelEvent:include(Serializable)

function LevelEvent:initialize(levelName, options)
    self.levelName = levelName
    self.options = options
end

return LevelEvent
