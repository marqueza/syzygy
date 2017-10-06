local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local PartyEnterEvent = class("PartyEnterEvent")
PartyEnterEvent:include(Serializable)

function PartyEnterEvent:initialize(args)
    args = args or {}
    self.leaderId = args.leaderId
    self.followerId = args.followerId
end

return PartyEnterEvent