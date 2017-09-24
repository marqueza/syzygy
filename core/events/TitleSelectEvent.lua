local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local TitleSelectEvent = class("TitleSelectEvent")
TitleSelectEvent:include(Serializable)

function TitleSelectEvent:initialize(args)
    args = args or {}
    self.selection = args.selection
end

return TitleSelectEvent