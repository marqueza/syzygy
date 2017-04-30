local lovetoys = require "lib.lovetoys.lovetoys"
local Mission  = lovetoys.Component.create("Mission")
local Serializable = require "data.serializable"
Mission:include(Serializable)

function Mission:initialize(args)
    self.turnsRemaining = args.turnsRemaining
end

return Mission
