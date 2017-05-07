local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local HireBrowseEvent = class("HireBrowseEvent")
HireBrowseEvent:include(Serializable)

function HireBrowseEvent:initialize(args)
    args = args or {}
end

return HireBrowseEvent
