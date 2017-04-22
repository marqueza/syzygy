local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local ReplayEvent = class("ReplayEvent")
ReplayEvent:include(Serializable)

function ReplayEvent:initialize(args)
    args = args or {}
end

return ReplayEvent
