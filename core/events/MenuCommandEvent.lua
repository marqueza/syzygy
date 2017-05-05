local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local MenuCommandEvent = class("MenuCommandEvent")
MenuCommandEvent:include(Serializable)

function MenuCommandEvent:initialize(args)
    self.key = args.key
end

return MenuCommandEvent
