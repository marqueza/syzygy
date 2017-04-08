MoveEvent = class("MoveEvent")

function MoveEvent:initialize(mover, newX, newY)
    self.mover = mover
    self.x = newX
    self.y = newY
    self.name = "MoveEvent"
end
function MoveEvent:reflect()
  local t = {}
  for v, k in pairs(self) do
    if k ~= "class" then
      t[k] = v
    end
  end
  return t
end