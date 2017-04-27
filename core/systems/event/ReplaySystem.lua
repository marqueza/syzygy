local lovetoys = "lib.lovetoys.lovetoys"
local serpent = require "serpent"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local events = require "core.events.events"
local ReplaySystem = class("ReplaySystem", System)

function ReplaySystem:initialize()
    self.name = "ReplaySystem"
    self.replayQueue = {}
    self.recording = false
end
function ReplaySystem:pushEventsFromSave(saveEvent)

  --read in desired events file
  local f = io.open(systems.saveSystem:getLatestDir() .. "/events.save.txt", 'r')
  local logString = f:read("*all")
  local ok, t = serpent.load(logString)
  assert(ok)
  --have a for loop fire each event
  print (#t)
  local count = 0
  for i, eventString in ipairs(t) do
      local ok, eventTable = serpent.load(eventString)
      assert(ok)
      if eventTable.class == "MoveEvent" then
          table.insert(self.replayQueue, events[eventTable.class](eventTable))
      end
  end
end

function ReplaySystem:popEvent(replayEvent)
    if #self.replayQueue > 0 then
        local eventInstance = self.replayQueue[1]
        table.remove(self.replayQueue, 1)
        events.fireEvent(eventInstance)
        events.fireEvent(events.LogEvent{
            text="[REPLAY] " .. eventInstance:toString(),
        })
    end
end
function ReplaySystem:pushEvent(event)
    if self.recording then
        events.fireEvent(events.LogEvent{
            text="[RECORD] " .. event:toString(),
        })
        table.insert(self.replayQueue, event)
    end
end
function ReplaySystem:toggleRecording(event)
    events.fireEvent(events.LogEvent{
            text="[TOGGLE] " .. event:toString(),
        })

    self.recording = not self.recording
end
return ReplaySystem
