local lovetoys = require "lib.lovetoys.lovetoys"
local Adventurer  = lovetoys.Component.create("Adventurer")
local Serializable = require "data.serializable"
Adventurer:include(Serializable)

--Adventuers require a chunk to be loaded
function Adventurer:initialize(args)
end

return Adventurer