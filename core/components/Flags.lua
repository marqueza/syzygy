local lovetoys = require "lib.lovetoys.lovetoys"
local Flags  = lovetoys.Component.create("Flags")
local Serializable = require "data.serializable"
Flags:include(Serializable)

function Flags:initialize(args)
    self.leavesCorpse = args.leavesCorpse
end

return Flags
