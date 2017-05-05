local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local MenuResultEvent = class("MenuResultEvent")
MenuResultEvent:include(Serializable)

function MenuResultEvent:initialize(args)
    args = args or {}
end

return MenuResultEvent
