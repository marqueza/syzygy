local lovetoys = "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local RecruitSystem = class("RecruitSystem", System)

--This class maintains the log arrays which in other systems
function RecruitSystem:initialize()
    self.name = "RecruitSystem"
end
function RecruitSystem:onEnterNotify(partyEnterEvent)
  local leader = systems.getEntityById(partyEnterEvent.leaderId)
  local follower = systems.getEntityById(partyEnterEvent.followerId)
  leader.Recruit.members[follower.id] = true
  events.fireEvent(events.LogEvent{text=subject.name .. " joins " .. interactor.name .. "."})
end
function RecruitSystem:onExitNotify(partyExitEvent)
  local leader = systems.getEntityById(partyExitEvent.leaderId)
  local follower = systems.getEntityById(partyExitEvent.followerId)
  leader.Recruit.members[follower.id] = nil
end
return RecruitSystem
