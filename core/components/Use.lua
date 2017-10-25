local lovetoys = require "lib.lovetoys.lovetoys"
local Use  = lovetoys.Component.create("Use")
local Serializable = require "data.serializable"
Use:include(Serializable)

function Use:initialize(args)
    self.eventName = args.eventName
    self.eventArgs = args.eventArgs
    self.userIdArg = args.userIdArg
    self.consumable = args.consumable or false
end
return Use
