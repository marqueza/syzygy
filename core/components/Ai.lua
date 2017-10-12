local lovetoys = require "lib.lovetoys.lovetoys"
local Ai  = lovetoys.Component.create("Ai")
local Serializable = require "data.serializable"
Ai:include(Serializable)

function Ai:initialize(args)
    self.combatPreference = args.combatPreference
    self.idle = args.idle
    
    --objective is the current goal of the entitiy
    -- for example dungeon means complete the dungeon
    self.objective = args.objective
    self.lastAction = "none"
end

return Ai
