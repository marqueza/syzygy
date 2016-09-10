local class = require "lib/middleclass"
require "player"
require "zone"
require "viewport"

Engine = class('Engine')
  
function Engine:initialize()
  self.player = Player()
  self.zone = Zone(self.player, "grey", 50, 50,"arena")
  self.viewport = Viewport(self.player, self.zone)
end

function Engine:movePlayer(dx,dy)
  if not (dx ==0 and dy == 0) then
        
        local newx = self.player.x+dx
        local newy = self.player.y+dy
        
        if self.zone.map[newx][newy]==0 then -- if the player is heading towards a floor
            self.player.x=newx -- move player
            self.player.y=newy
            
            self.player.sprite.grid_x = self.player.x*64
            self.player.sprite.grid_y = self.player.y*64
        end
    end
end

