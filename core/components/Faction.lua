local lovetoys = require "lib.lovetoys.lovetoys"
local Faction  = lovetoys.Component.create("Faction")
local Serializable = require "data.serializable"
Faction:include(Serializable)

function Faction:initialize(args)
    self.name = args.name
end

return Faction
