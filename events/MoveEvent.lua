MoveEvent = class("MoveEvent")

function MoveEvent:initialize(mover, newX, newY)
    self.mover = mover
    self.x = newX
    self.y = newY
end