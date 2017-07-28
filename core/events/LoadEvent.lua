local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local LoadEvent = class("LoadEvent")
LoadEvent:include(Serializable)

function LoadEvent:initialize(args)
    args = args or {}
    self.saveSlot = args.saveSlot or "latest"
    self.loadType = args.loadType or "full"
    self.prefix = args.prefix or ""
end

return LoadEvent
