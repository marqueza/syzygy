local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local ToggleRecording = class("ToggleRecording")
ToggleRecording:include(Serializable)

function ToggleRecording:initialize(args)
    args = args or {}
end

return ToggleRecording
