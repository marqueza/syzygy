local lovetoys = "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local events = require "core.events.events"
local PartySystem = class("PartySystem", System)

--This class maintains the log arrays which in other systems
function PartySystem:initialize()
  self.name = "PartySystem"
end
function PartySystem:onEnterNotify(partyEnterEvent)
  local leader = systems.getEntityById(partyEnterEvent.leaderId)
  local follower = systems.getEntityById(partyEnterEvent.followerId)
  leader.Party.members[follower.id] = true
end
function PartySystem:onExitNotify(partyExitEvent)
  local leader = systems.getEntityById(partyExitEvent.leaderId)
  local follower = systems.getEntityById(partyExitEvent.followerId)
  leader.Party.members[follower.id] = nil
end
function PartySystem.getMemberIds(leader)
  assert(leader.Party, "Entity " .. leader.name .. "" .. leader.id.." does not have 'Party'")
  local keys={}
  local n=0
  for k,v in pairs(leader.Party.members) do
    n=n+1
    keys[n]=k
  end
  return keys
end
return PartySystem
