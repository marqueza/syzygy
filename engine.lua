local class = require "lib/middleclass"
require "player"
require "zone"
require "viewport"
require "item"

Engine = class('Engine')
  
function Engine:initialize()
  self.player = Player()
  self.zone = Zone(self.player, "grey", 40, 40,"arena")
  
  self.zone:spawnItem(Item("key",1,1, 1,1))
  
  
  self.viewport = Viewport(self.player, self.zone)
  
end

function Engine:movePlayer(dx,dy)
  if not (dx ==0 and dy == 0) then
        
        local newx = self.player.x+dx
        local newy = self.player.y+dy
        
        if self.zone.map[newx][newy]~=1 then -- if the player is heading towards a floor
            self.player:move(dx,dy)
        end
    end
end

