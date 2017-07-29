local lovetoys = require "lib.lovetoys.lovetoys"
local Inventory  = lovetoys.Component.create("Inventory")
local Serializable = require "data.serializable"
Inventory:include(Serializable)

function Inventory:initialize(args)
    self.itemIds = args.itemIds or {}
end

return Inventory