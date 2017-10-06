local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local PartyExitEvent = class("PartyExitEvent")
PartyExitEvent:include(Serializable)

function PartyExitEvent:initialize(args)
    args = args or {}
    self.leaderId = args.leaderId
    self.followerId = args.followerId
end

return PartyExitEvent