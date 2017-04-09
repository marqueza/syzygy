MessageEvent = class("MessageEvent")
local engine = require "core.engine"

function MessageEvent:initialize(text)
    self.text = text
    self.name = "MessageEvent"
end
function MessageEvent:reflect()
  local t = {}
  for v, k in pairs(self) do
    if k ~= "class" then
      t[k] = v
    end
  end
  return t
end
