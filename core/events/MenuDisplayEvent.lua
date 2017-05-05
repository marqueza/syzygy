local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local MenuDisplayEvent = class("MenuDisplayEvent")
MenuDisplayEvent:include(Serializable)

function MenuDisplayEvent:initialize(args)
    args = args or {}
    self.type = args.type
    self.choices = args.choices
    self.title = args.title
    self.resultKey = args.resultKey
    self.resultEvent = args.resultEvent
    self.resultEventArgs = args.resultEventArgs
end

return MenuDisplayEvent
