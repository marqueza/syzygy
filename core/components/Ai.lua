local lovetoys = require "lib.lovetoys.lovetoys"
local Ai  = lovetoys.Component.create("Ai")
local Serializable = require "data.serializable"
Ai:include(Serializable)

function Ai:initialize(args)
    self.combatPreference = args.combatPreference
    self.idle = args.idle
end

return Ai
