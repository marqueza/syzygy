local class = require "lib/middleclass"
require "player"
require "zone"
require "viewport"

Engine = class('Engine')
  
function Engine:initialize()
  self.player = Player()
  self.zone = Zone(self.player, "grey", 15, 15,"arena")
  self.viewport = Viewport(self.player, self.zone)
end

