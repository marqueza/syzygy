local class = require "lib/middleclass"
require "actor"

Player = class("Player", Actor)

function Player:initialize(x, y)
  Actor.initialize(self, x or 1, y or 1,"player")--invoke parent class Actor
end

