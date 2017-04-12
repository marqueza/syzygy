local lovetoys = require "lib.lovetoys.lovetoys"
local physics  = lovetoys.Component.create("physics")
local Serializable = require "data.serializable"
physics:include(Serializable)

function physics:initialize(args)
    self.x = args.x
    self.y = args.y
    self.blocks = args.blocks
    self.hp = args.hp or 10
end
