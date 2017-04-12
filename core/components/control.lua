local lovetoys = require "lib.lovetoys.lovetoys"
local control = lovetoys.Component.create("control")
local Serializable = require "data.serializable"
control:include(Serializable)

function control:initialize()
end
