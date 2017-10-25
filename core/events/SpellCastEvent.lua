local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local SpellCastEvent = class("SpellCastEvent")
SpellCastEvent:include(Serializable)

function SpellCastEvent:initialize(args)
  self.spellName = args.spellName
  self.casterId = args.casterId
end

return SpellCastEvent
