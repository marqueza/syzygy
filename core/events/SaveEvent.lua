local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local SaveEvent = class("SaveEvent")
SaveEvent:include(Serializable)

function SaveEvent:initialize()
end

return SaveEvent
