local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local TitleEnterEvent = class("TitleEnterEvent")
TitleEnterEvent:include(Serializable)

function TitleEnterEvent:initialize(args)
    args = args or {}
end

return TitleEnterEvent
