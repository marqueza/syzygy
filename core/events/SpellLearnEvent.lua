local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local SpellLearnEvent = class("SpellLearnEvent")
SpellLearnEvent:include(Serializable)

function SpellLearnEvent:initialize(args)
  self.spellName = args.spellName
  self.learnerId = args.learnerId
end

return SpellLearnEvent
