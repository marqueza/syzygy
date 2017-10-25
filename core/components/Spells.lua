local lovetoys = require "lib.lovetoys.lovetoys"
local Spells = lovetoys.Component.create("Spells")
local Serializable = require "data.serializable"
Spells:include(Serializable)

function Spells:initialize(args)
  args = args or {}
  self.names = args.names or {}
end

return Spells