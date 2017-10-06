local lovetoys = require "lib.lovetoys.lovetoys"
local Party  = lovetoys.Component.create("Party")
local Serializable = require "data.serializable"
Party:include(Serializable)

--Adventuers require a chunk to be loaded
function Party:initialize(args)
  self.members = args.members or {}
end

return Party