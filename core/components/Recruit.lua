local lovetoys = require "lib.lovetoys.lovetoys"
local Recruit  = lovetoys.Component.create("Recruit")
local Serializable = require "data.serializable"
Recruit:include(Serializable)
function Recruit:initialize(args)
  args = args or {}
  self.desire = args.desire
  self.amount = args.amount
end

return Recruit
