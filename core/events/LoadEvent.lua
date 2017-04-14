local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local LoadEvent = class("LoadEvent")
LoadEvent:include(Serializable)

function LoadEvent:initialize()
end

return LoadEvent
