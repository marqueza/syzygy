local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local CommandKeyEvent = class("CommandKeyEvent")
CommandKeyEvent:include(Serializable)

function CommandKeyEvent:initialize(key)
    self.key = key
end

return CommandKeyEvent
