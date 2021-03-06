local lovetoys = require "lib.lovetoys.lovetoys"
local Physics  = lovetoys.Component.create("Physics")
local Serializable = require "data.serializable"
Physics:include(Serializable)

function Physics:initialize(args)
    assert(args, "The args table has not been provided")
    self.x = args.x
    self.y = args.y
    self.blocks = args.blocks
    self.layer = args.layer
    self.allowsFov = args.allowsFov
    assert(args.plane, "You are missing a plane for the Physics component")
    self.plane = args.plane
end

return Physics
