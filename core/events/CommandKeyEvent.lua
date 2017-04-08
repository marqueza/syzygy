CommandKeyEvent = class("CommandKeyEvent")

function CommandKeyEvent:initialize(key)
    self.key = key
    self.name = "CommandKeyEvent"
end
function CommandKeyEvent:reflect()
  local t = {}
  for k, v in pairs(self) do
    if not string.match(k, "class") then
      t[k] = v
    end
  end
  return t
end