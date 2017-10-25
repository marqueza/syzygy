local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local SpellDisplayEvent = class("SpellDisplayEvent")
SpellDisplayEvent:include(Serializable)

function SpellDisplayEvent:initialize(args)
  self.casterId = args.casterId
end

return SpellDisplayEvent
