local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local LoadEvent = class("LoadEvent")
LoadEvent:include(Serializable)

function LoadEvent:initialize(args)
    args = args or {}
    self.saveSlot = args.saveSlot or "latest"
end

return LoadEvent
