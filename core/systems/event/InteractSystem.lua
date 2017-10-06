local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local events = require "core.events.events"
local systems = require "core.systems.systems"
local components = require "core.components.components"
local InteractSystem = class("InteractSystem", System)

local _setupMainMenu

function InteractSystem:initialize()
    lovetoys.System.initialize(self)
    self.name = "InteractSystem"
end

--There will be the subject and the interacter
--For example the player will interact the wood sprite
--options may be trade, recruit, or mission (if  ally)
function InteractSystem:onEnterNotify(interactEnterEvent)
  local interactor = systems.getEntityById(interactEnterEvent.interactorId)
  local subject = systems.getEntityById(interactEnterEvent.subjectId)
  --now determine what choices are avalible for selection
  --recruit will be always on.
  --mission only on if faction is the same.
  if (subject.Recruit) then
     events.fireEvent(events.MenuDisplayEvent{
        type="string",
        choices={"recruit"},
        resultKey="selection",
        resultEvent=events.InteractSelectEvent,
        resultEventArgs={
          subjectId=interactEnterEvent.subjectId,
          interactorId=interactEnterEvent.interactorId,
          },
      })
  end
end

function InteractSystem:onSelectNotify(interactSelectEvent)
  local interactor = systems.getEntityById(interactSelectEvent.interactorId)
  local subject = systems.getEntityById(interactSelectEvent.subjectId)
  if interactSelectEvent.selection == "recruit" then
    local amountAvaliable = systems.inventorySystem:getItemAmount(interactor, subject.Recruit.desire)
    if (amountAvaliable >= subject.Recruit.amount) then
      --recruitment
      --change faction to yours
      subject.Faction.name = interactor.Faction.name
      subject.Recruit.leaderId = interactor.id
      subject.Ai.objective = "go"
      table.insert(interactor.Party.memberIds, subject.id)
      events.fireEvent(events.LogEvent{text=subject.name .. " joins " .. interactor.name .. "."})

    else
      --say that you need more
      events.fireEvent(events.LogEvent{text=interactor.name .. " needs more " .. subject.Recruit.desire.. "."})
    end
  end
end

function InteractSystem:draw()
end
function InteractSystem:requires()
    return {}
end

return InteractSystem
