local lovetoys = require "lib.lovetoys.lovetoys"
local Follower  = lovetoys.Component.create("Follower")
local Serializable = require "data.serializable"
Follower:include(Serializable)
function Follower:initialize(args)
  args = args or {}
  self.leaderId = args.leaderId
end

return Follower