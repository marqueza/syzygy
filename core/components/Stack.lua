local lovetoys = require "lib.lovetoys.lovetoys"
local Stack  = lovetoys.Component.create("Stack")
local Serializable = require "data.serializable"
Stack:include(Serializable)

function Stack:initialize(args)
    args = args or {}
    self.amount = args.amount or 1
end

return Stack
