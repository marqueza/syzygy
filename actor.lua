local class = require "lib/middleclass"
require "enitity"

Actor = class("Actor", Enitity)
  
function Actor:initialize(x, y, name)
  Enitity.initialize(self, x, y, name)--invoke parent class Enitity
end

