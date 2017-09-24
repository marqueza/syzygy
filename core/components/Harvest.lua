local lovetoys = require "lib.lovetoys.lovetoys"
local Harvest  = lovetoys.Component.create("Harvest")
local Serializable = require "data.serializable"
Harvest:include(Serializable)
function Harvest:initialize(args)
  args = args or {}
  self.loot = args.loot
end

return Harvest
